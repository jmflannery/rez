require 'test_helper'

module Rez
  describe SectionsController do
    setup do
      @routes = Engine.routes
    end

    describe 'POST create' do
      let(:section_attrs) { FactoryGirl.attributes_for(:section) }

      describe "with a valid Toke key in the header" do

        let(:current_user) { FactoryGirl.create(:user) }
        let(:token) { FactoryGirl.create(:token, user: current_user) }
        before do request.headers['X-Toke-Key'] = token.key end

        it "responds with 201 Created" do
          post :create, section: section_attrs#, use_route: 'rez'
          response.status.must_equal 201
        end

        it "creates a new Section" do
          assert_difference('Section.count', 1) do
            post :create, section: section_attrs#, use_route: 'rez'
          end
        end

        it "sets the new Section fields" do
          post :create, section: section_attrs#, use_route: 'rez'
          json_resp = json(response, 'section')
          json_resp[:name].must_equal section_attrs[:name]
          json_resp[:heading].must_equal section_attrs[:heading]
          json_resp[:subheading].must_equal section_attrs[:subheading]
        end

        describe 'without a name given' do

          before do section_attrs[:name] = '' end

          it 'responds with 400 Bad Request' do
            post :create, section: section_attrs#, use_route: 'rez'
            response.status.must_equal 400
          end

          it "returns a hash with the error message" do
            post :create, section: section_attrs#, use_route: 'rez'
            response.body.must_equal({name: ["can't be blank"]}.to_json)
          end
        end
      end

      describe "with an invalid Toke key in the header" do

        let(:token) { FactoryGirl.create(:token) }
        before do request.headers['X-Toke-Key'] = token.key end

        it "responds with 401 Unauthorized" do
          post :create, section: section_attrs#, use_route: 'rez'
          response.status.must_equal 401
        end
      end
    end

    describe 'GET index' do

      let(:section1) { FactoryGirl.create(:section) }
      let(:section2) { FactoryGirl.create(:section) }

      before do
        @sections = [section1, section2]
      end

      it 'responds with 200 OK' do
        get :index#, use_route: 'rez'
        response.status.must_equal 200
      end

      it "returns all the Sections in JSON format" do
        get :index#, use_route: 'rez'
        serializer = ActiveModel::ArraySerializer.new(@sections, each_serializer: SectionSerializer)
        response.body.must_equal({ sections: serializer }.to_json)
      end

      describe "if resume_id is given" do

        let(:section3) { FactoryGirl.create(:section) }

        before do
          @resume = FactoryGirl.create(:resume)
          @resume.add_section(section1)
          @resume.add_section(section3)
        end

        it "returns only the sections for the given resume" do
          get :index, resume_id: @resume.id#, use_route: 'rez'
          resp_json = json(response, 'sections')
          resp_json.size.must_equal 2
          resp_json[0]['id'].must_equal section1.id
          resp_json[1]['id'].must_equal section3.id
        end

        describe "resume_id is invalid" do

          it "responds with 404 Not Found" do
            get :index, resume_id: 'wrong'#, use_route: 'rez'
            response.status.must_equal 404
          end
        end
      end
    end

    describe "GET show" do

      let(:section) { FactoryGirl.create(:section) }

      describe "given a valid section id" do

        it "responds with 200 OK" do
          get :show, id: section#, use_route: 'rez'
          response.status.must_equal 200
        end

        it "responds with the requested section in JSON format" do
          get :show, id: section#, use_route: 'rez'
          response.body.must_equal(SectionSerializer.new(section).to_json)
        end
      end

      describe "given an invalid section id" do

        it "responds with 404 Not Found" do
          get :show, id: 'wrong'#, use_route: 'rez'
          response.status.must_equal 404
        end
      end
    end

    describe "PUT update" do

      let(:section) { FactoryGirl.create(:section) }
      let(:update_attrs) {{ name: 'my section', heading: 'My Awesome Heading', subheading: 'My Sweet Sub-heading' }}

      describe "with a valid Toke key in the header" do

        let(:current_user) { FactoryGirl.create(:user) }
        let(:token) { FactoryGirl.create(:token, user: current_user) }
        before do request.headers['X-Toke-Key'] = token.key end

        describe "on successfull update" do

          it "responds with 200 OK" do
            put :update, id: section, section: update_attrs#, use_route: 'rez'
            response.status.must_equal 200
          end

          it "updates the section record" do
            put :update, id: section, section: update_attrs#, use_route: 'rez'
            section.reload.heading.must_equal('My Awesome Heading')
            section.subheading.must_equal('My Sweet Sub-heading')
          end

          it "returns the updated section in JSON format" do
            put :update, id: section, section: update_attrs#, use_route: 'rez'
            response.body.must_equal(SectionSerializer.new(section.reload).to_json)
          end

          describe "updating the Section's Items" do

            let(:item1) { FactoryGirl.create(:item) }
            let(:item2) { FactoryGirl.create(:item) }
            let(:update_attrs) {{
              item_ids: [item1.id, item2.id],
              name: 'New name',
              heading: 'New heading',
              subheading: 'New subheading'
            }}

            it "updates the Section's item_ids" do
              put :update, id: section, section: update_attrs#, use_route: 'rez'
              section.reload.item_ids.must_equal [item1.id, item2.id]
            end

            it "does not update invalid item ids" do
              update_attrs[:item_ids] << 1234
              put :update, id: section, section: update_attrs#, use_route: 'rez'
              section.reload.item_ids.wont_include 1234
            end

            it 'does not insert duplicate items' do
              update_attrs[:item_ids] << item1.id
              put :update, id: section, section: update_attrs#, use_route: 'rez'
              section.reload.item_ids.must_equal [item1.id, item2.id]
            end

            describe 'when the section already has items(s)' do

              before do
                section.add_item item1
                update_attrs[:item_ids].delete_at(0)
              end

              it 'items not given in item_ids are removed from the section' do
                put :update, id: section, section: update_attrs#, use_route: 'rez'
                section.reload.item_ids.wont_include item1.id
              end
            end
          end
        end

        describe "given an invalid section id" do

          it "responds with 404 Not Found" do
            put :update, id: 'nope', section: update_attrs#, use_route: 'rez'
            response.status.must_equal 404
          end
        end
      end

      describe "with an invalid Toke key in the header" do

        let(:token) { FactoryGirl.create(:token) }
        before do request.headers['X-Toke-Key'] = token.key end

        it "responds with 401 Unauthorized" do
          put :update, id: section, section: update_attrs#, use_route: 'rez'
          response.status.must_equal 401
        end
      end
    end

    describe "DELETE destroy" do

      before do @section = FactoryGirl.create(:section) end

      describe "with a valid Toke key in the header" do

        let(:current_user) { FactoryGirl.create(:user) }
        let(:token) { FactoryGirl.create(:token, user: current_user) }
        before do request.headers['X-Toke-Key'] = token.key end

        describe "given a valid section id" do

          it "destroys the section" do
            assert_difference('Section.count', -1) do
              delete :destroy, id: @section#, use_route: 'rez'
            end
          end

          it "responds with 204 No Content" do
            delete :destroy, id: @section#, use_route: 'rez'
            response.status.must_equal 204
            response.body.must_equal ''
          end
        end

        describe "given an invalid section id" do

          it "responds with 404 Not Found" do
            delete :destroy, id: 'wrong'#, use_route: 'rez'
            response.status.must_equal 404
          end
        end
      end

      describe "with an invalid Toke key in the header" do

        let(:token) { FactoryGirl.create(:token) }
        before do request.headers['X-Toke-Key'] = token.key end

        it "responds with 401 Unauthorized" do
          delete :destroy, id: @section#, use_route: 'rez'
          response.status.must_equal 401
        end
      end
    end
  end
end
