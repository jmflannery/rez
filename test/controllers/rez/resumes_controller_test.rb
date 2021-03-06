require 'test_helper'

module Rez
  describe ResumesController do
    setup do
      @routes = Engine.routes
    end

    describe "POST create" do

      describe "with a valid Toke key in the header" do

        let(:current_user) { FactoryGirl.create(:user) }
        let(:token) { FactoryGirl.create(:token, user: current_user) }
        before do request.headers['X-Toke-Key'] = token.key end

        describe "given a valid resume name" do

          let(:params) {{ name: 'My Resume' }}

          it "responds with 201 Created" do
            post :create, resume: params
            response.status.must_equal 201
          end

          it "creates a Resume" do
            assert_difference('Resume.count', 1) do
              post :create, resume: params
            end
          end

          it "returns the created Resume in JSON format" do
            post :create, resume: params
            response.body.must_equal ResumeSerializer.new(assigns(:resume)).to_json
          end
        end

        describe "given no resume name" do

          let(:params) {{ name: '' }}

          it "responds with 422 Bad Request" do
            post :create, resume: params
            response.status.must_equal 422
          end

          it "returns a hash with the error message" do
            post :create, resume: params
            response.body.must_equal({name: ["can't be blank"]}.to_json)
          end
        end
      end

      describe "with an invalid Toke key in the header" do

        let(:token) { FactoryGirl.create(:token) }
        before do request.headers['X-Toke-Key'] = token.key end

        it "responds with 401 Unauthorized" do
          post :create
          response.status.must_equal 401
        end
      end
    end

    describe "GET index" do

      let(:resume) { FactoryGirl.create(:resume) }
      let(:resume2) { FactoryGirl.create(:resume) }

      before do @resumes = [resume, resume2] end

      it "returns all the Resumes in JSON format" do
        get :index
        serializer = ActiveModel::ArraySerializer.new(@resumes, each_serializer: ResumeSerializer)
        response.body.must_equal({ resumes: serializer }.to_json)
      end
    end

    describe "GET show" do

      let(:resume) { FactoryGirl.create(:resume) }

      describe "given a valid Resume id" do

        it "responds with the requested Resume in JSON format" do
          get :show, id: resume
          response.body.must_equal(ResumeSerializer.new(resume).to_json)
        end
      end

      describe "given an invalid Resume id" do

        it "responds with 404 Bad Request" do
          get :show, id: 'wrong'
          response.status.must_equal 404
        end
      end
    end

    describe "PUT update" do

      let(:resume) { FactoryGirl.create(:resume, name: 'My Resume') }
      let(:update_attrs) {{ name: 'My Awesome Resume' }}

      describe "with a valid Toke key in the header" do

        let(:current_user) { FactoryGirl.create(:user) }
        let(:token) { FactoryGirl.create(:token, user: current_user) }
        before do request.headers['X-Toke-Key'] = token.key end

        describe "on successfull update" do

          it "updates the resume record" do
            put :update, id: resume, resume: update_attrs
            resume.reload.name.must_equal('My Awesome Resume')
          end

          it "returns the updated resume in JSON format" do
            put :update, id: resume, resume: update_attrs
            response.body.must_equal(ResumeSerializer.new(resume.reload).to_json)
          end

          describe 'updating the Profile' do

            describe 'given a valid profile id' do

              let(:profile) { FactoryGirl.create(:profile, firstname: 'Jaxon', nickname: 'Jax') }
              let(:update_attrs) {{ profile_id: profile.id, name: 'Business Resume' }}

              it "updates the Resume's Profile" do
                put :update, id: resume, resume: update_attrs
                resume.reload.profile.id.must_equal profile.id
              end

              it "returns the updated resume in JSON format with embedded Profile" do
                put :update, id: resume, resume: update_attrs
                json = JSON.parse(response.body)
                json['resume']['profile'].to_json.must_equal ProfileSerializer.new(profile, root: false).to_json
                json['resume']['name'].must_equal 'Business Resume'
              end
            end

            describe 'given an invalid profile id' do

              let(:update_attrs) {{ profile_id: 'wrong' }}

              it 'responds with 400 Bad Request' do
                put :update, id: resume, resume: update_attrs
                response.status.must_equal 400
              end

              it 'responds with a JSON formatted error message' do
                put :update, id: resume, resume: update_attrs
                response.body.must_equal({ profile_id: "Profile wrong not found" }.to_json)
              end
            end
          end

          describe 'updating the Address' do

            describe 'given a valid address id' do

              let(:address) { FactoryGirl.create(:address, building_number: '22', street_name: 'G St') }
              let(:update_attrs) {{ address_id: address.id, name: 'Fun Resume' }}

              it "updates the Resume's Address" do
                put :update, id: resume, resume: update_attrs
                resume.reload.address.id.must_equal address.id
              end

              it "returns the updated resume in JSON format with address_id" do
                put :update, id: resume, resume: update_attrs
                json = JSON.parse(response.body)
                json['resume']['address'].to_json.must_equal AddressSerializer.new(address, root: false).to_json
                json['resume']['name'].must_equal 'Fun Resume'
              end
            end

            describe 'given an invalid address id' do

              let(:update_attrs) {{ address_id: 'wrong' }}

              it 'responds with 400 Bad Request' do
                put :update, id: resume, resume: update_attrs
                response.status.must_equal 400
              end

              it 'responds with a JSON formatted error message' do
                put :update, id: resume, resume: update_attrs
                response.body.must_equal({ address_id: "Address wrong not found" }.to_json)
              end
            end
          end

          describe 'updating the Items' do

            let(:item1) { FactoryGirl.create(:item) }
            let(:item2) { FactoryGirl.create(:item) }
            let(:update_attrs) {{ item_ids: [item1.id, item2.id], name: 'Fun Resume' }}

            it "updates the Resumes Item's" do
              put :update, id: resume, resume: update_attrs
              resume.reload.item_ids.must_equal [item1.id, item2.id]
            end

            it 'does not update invalid item ids' do
              update_attrs[:item_ids] << 1234
              put :update, id: resume, resume: update_attrs
              resume.reload.item_ids.wont_include 1234
            end

            it 'does not insert duplicate items' do
              update_attrs[:item_ids] << item1.id
              put :update, id: resume, resume: update_attrs
              resume.reload.item_ids.must_equal [item1.id, item2.id]
            end

            it 'removes items from the resume that are not given in item_ids' do
              resume.items << item1
              update_attrs[:item_ids].delete_at(0)
              put :update, id: resume, resume: update_attrs
              resume.reload.items.wont_include item1
            end

            it 'removes all items if items_ids key is nil or empty' do
              resume.items << item1 << item2
              update_attrs[:item_ids] = nil
              put :update, id: resume, resume: update_attrs
              resume.reload.items.must_be_empty
            end
          end
        end

        describe "given an invalid resume id" do

          it "responds with 404 Bad Request" do
            put :update, id: 'nope', resume: update_attrs
            response.status.must_equal 404
          end
        end

        describe "given an invalid resume name" do

          let(:invalid_attrs) {{ name: '' }}

          it "responds with 422 Unprocessable Entity" do
            put :update, id: resume, resume: invalid_attrs
            response.status.must_equal 422
          end

          it "returns the errors in JSON format" do
            put :update, id: resume, resume: invalid_attrs
            response.body.must_equal({ name: ["can't be blank"]}.to_json)
          end
        end
      end

      describe "with an invalid Toke key in the header" do

        let(:token) { FactoryGirl.create(:token) }
        before do request.headers['X-Toke-Key'] = token.key end

        it "responds with 401 Unauthorized" do
          put :update, id: resume, resume: update_attrs
          response.status.must_equal 401
        end
      end
    end

    describe "DELETE destroy" do

      before do @resume = FactoryGirl.create(:resume) end

      describe "with a valid Toke key in the header" do

        let(:current_user) { FactoryGirl.create(:user) }
        let(:token) { FactoryGirl.create(:token, user: current_user) }
        before do request.headers['X-Toke-Key'] = token.key end

        describe "given a valid Resume id" do

          it "destroys the resume" do
            assert_difference('Resume.count', -1) do
              delete :destroy, id: @resume
            end
          end

          it "responds with 204 No Content" do
            delete :destroy, id: @resume
            response.status.must_equal 204
            response.body.must_equal ''
          end
        end

        describe "given an invalid Resume id" do

          it "responds with 404 Bad Request" do
            delete :destroy, id: 'wrong'
            response.status.must_equal 404
          end
        end
      end

      describe "with an invalid Toke key in the header" do

        let(:token) { FactoryGirl.create(:token) }
        before do request.headers['X-Toke-Key'] = token.key end

        it "responds with 401 Unauthorized" do
          delete :destroy, id: @resume
          response.status.must_equal 401
        end
      end
    end
  end
end
