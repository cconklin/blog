require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  render_views
  # This should return the minimal set of attributes required to create a valid
  # Comment. As you add validations to Comment, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {body: "This is a body!", post: comment_post}
  }

  let(:comment_post) {
    Post.create! title: "Post Title", body: "This is a body!"
  }

  let(:invalid_attributes) {
    {body: ""}
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # CommentsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Comment" do
        expect {
          post :create, {post_id: comment_post.to_param, :comment => valid_attributes}, valid_session
        }.to change(Comment, :count).by(1)
      end

      it "assigns a newly created comment as @comment" do
        post :create, {post_id: comment_post.to_param, :comment => valid_attributes}, valid_session
        expect(assigns(:comment)).to be_a(Comment)
        expect(assigns(:comment)).to be_persisted
      end

      it "redirects to the comment's post" do
        post :create, {post_id: comment_post.to_param, :comment => valid_attributes}, valid_session
        expect(response).to redirect_to(comment_post)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved comment as @comment" do
        post :create, {post_id: comment_post.to_param, :comment => invalid_attributes}, valid_session
        expect(assigns(:comment)).to be_a_new(Comment)
      end

      it "re-renders the posts 'show' template" do
        post :create, {post_id: comment_post.to_param, :comment => invalid_attributes}, valid_session
        expect(response).to render_template("posts/show")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested comment" do
      comment = Comment.create! valid_attributes
      expect {
        delete :destroy, {post_id: comment_post.to_param, :id => comment.to_param}, valid_session
      }.to change(Comment, :count).by(-1)
    end

    it "redirects to the comments list" do
      comment = Comment.create! valid_attributes
      delete :destroy, {post_id: comment_post.to_param, :id => comment.to_param}, valid_session
      expect(response).to redirect_to(comment_post)
    end
  end

end
