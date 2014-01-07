require 'test_helper'

module Rez
  describe ParagraphsController do

    describe "POST create" do

      let(:attrs) { FactoryGirl.attributes_for(:paragraph) }

      it "responds with 201 Created" do
        post :create, paragraph: attrs, use_route: 'rez'
        response.status.must_equal 201
      end
      
      it "creates a Paragraph" do
        assert_difference('Paragraph.count', 1) do
          post :create, paragraph: attrs, use_route: 'rez'
        end
      end
    end
  end
end
