require 'test_helper'

module Rez
  describe ResumesController do

    describe "POST create" do

      describe "with a valid Toke key in the header" do

        let(:current_user) { FactoryGirl.create(:user) }
        let(:token) { FactoryGirl.create(:token, user: current_user) }
        before do request.headers['X-Toke-Key'] = token.key end

        describe "given a valid resume name" do

          let(:params) {{ name: 'My Resume' }}

          it "responds with 201 Created" do
            post :create, resume: params, use_route: 'rez'
            response.status.must_equal 201
          end

          it "creates a Resume" do
            assert_difference('Resume.count', 1) do
              post :create, resume: params, use_route: 'rez'
            end
          end

          it "returns the created Resume in JSON format" do
            post :create, resume: params, use_route: 'rez'
            response.body.must_equal ResumeSerializer.new(assigns(:resume)).to_json
          end
        end

        describe "given no resume name" do

          let(:params) {{ name: '' }}

          it "responds with 400 Bad Request" do
            post :create, resume: params, use_route: 'rez'
            response.status.must_equal 400
          end

          it "returns a hash with the error message" do
            post :create, resume: params, use_route: 'rez'
            response.body.must_equal({name: ["can't be blank"]}.to_json)
          end
        end
      end

      describe "with an invalid Toke key in the header" do

        let(:token) { FactoryGirl.create(:token) }
        before do request.headers['X-Toke-Key'] = token.key end

        it "responds with 401 Unauthorized" do
          post :create, use_route: 'rez'
          response.status.must_equal 401
        end
      end
    end

    describe "GET index" do

      let(:resume) { FactoryGirl.create(:resume) }
      let(:resume2) { FactoryGirl.create(:resume) }

      before do
        @resumes = [resume, resume2]
      end

      it "responds with 200 OK" do
        get :index, use_route: 'rez'
        response.status.must_equal 200
      end

      it "returns all the Resumes in JSON format" do
        get :index, use_route: 'rez'
        serializer = ActiveModel::ArraySerializer.new(@resumes, each_serializer: ResumeSerializer)
        response.body.must_equal({ resumes: serializer }.to_json)
      end
    end

    describe "GET show" do

      let(:resume) { FactoryGirl.create(:resume) }

      describe "given a valid Resume id" do

        it "responds with 200 OK" do
          get :show, id: resume, use_route: 'rez'
          response.status.must_equal 200
        end

        it "responds with the requested Resume in JSON format" do
          get :show, id: resume, use_route: 'rez'
          response.body.must_equal(ResumeSerializer.new(resume).to_json)
        end
      end

      describe "given an invalid Resume id" do

        it "responds with 404 Not Found" do
          get :show, id: 'wrong', use_route: 'rez'
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
            put :update, id: resume, resume: update_attrs, use_route: 'rez'
            resume.reload.name.must_equal('My Awesome Resume')
          end

          it "returns the updated resume in JSON format" do
            put :update, id: resume, resume: update_attrs, use_route: 'rez'
            response.body.must_equal(ResumeSerializer.new(resume.reload).to_json)
          end
        end

        describe "given an invalid resume id" do

          it "responds with 404 Not Found" do
            put :update, id: 'nope', resume: update_attrs, use_route: 'rez'
            response.status.must_equal 404
          end
        end

        describe "given an invalid resume name" do

          let(:invalid_attrs) {{ name: '' }}

          it "responds with 422 Unprocessable Entity" do
            put :update, id: resume, resume: invalid_attrs, use_route: 'rez'
            response.status.must_equal 422
          end

          it "returns the errors in JSON format" do
            put :update, id: resume, resume: invalid_attrs, use_route: 'rez'
            response.body.must_equal({ name: ["can't be blank"]}.to_json)
          end
        end
      end

      describe "with an invalid Toke key in the header" do

        let(:token) { FactoryGirl.create(:token) }
        before do request.headers['X-Toke-Key'] = token.key end

        it "responds with 401 Unauthorized" do
          put :update, id: resume, resume: update_attrs, use_route: 'rez'
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
              delete :destroy, id: @resume, use_route: 'rez'
            end
          end 

          it "responds with 204 No Content" do
            delete :destroy, id: @resume, use_route: 'rez'
            response.status.must_equal 204
            response.body.must_equal ''
          end
        end

        describe "given an invalid Resume id" do

          it "responds with 404 Not Found" do
            delete :destroy, id: 'wrong', use_route: 'rez'
            response.status.must_equal 404
          end
        end
      end

      describe "with an invalid Toke key in the header" do

        let(:token) { FactoryGirl.create(:token) }
        before do request.headers['X-Toke-Key'] = token.key end

        it "responds with 401 Unauthorized" do
          delete :destroy, id: @resume, use_route: 'rez'
          response.status.must_equal 401
        end
      end
    end
  end
end
