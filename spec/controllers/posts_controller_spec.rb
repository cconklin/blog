require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  render_views
  # This should return the minimal set of attributes required to create a valid
  # Post. As you add validations to Post, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {title: "My Big Fat Greek Post", body: "This is a body!", author: user}
  }

  let(:invalid_attributes) {
    {title: "Only a title", body: ""}
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # PostsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  let(:user) { User.create! name: "User", email: "user@site.com", password: "my-totally-secure-password", roles: [] }

  describe "GET #index" do
    it "assigns all posts as @posts" do
      post = Post.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:posts)).to eq([post])
    end
  end

  describe "GET #show" do
    context "with no comments" do
      let(:post) { Post.create! valid_attributes }
      before do
        get :show, {:id => post.to_param}, valid_session      
      end
      it "assigns the requested post as @post" do
        expect(assigns(:post)).to eq(post)
      end
  
      it "assigns a new comment to @comment" do
        expect(assigns(:comment)).to be_a_new(Comment)
      end
    end
    context "with comments" do
      let(:comment) { Comment.new body: "Comment", author: user }
      let(:valid_attributes) {
        {title: "My Big Fat Greek Post", body: "This is a body!", comments: [comment], author: user}
      }
      let(:post) { Post.create! valid_attributes }
      before do
        get :show, {:id => post.to_param}, valid_session      
      end
      it "assigns the requested post as @post" do
        expect(assigns(:post)).to eq(post)
      end
    
      it "assigns a new comment to @comment" do
        expect(assigns(:comment)).to be_a_new(Comment)
      end
    end
  end

  context "as a non-administrator" do

    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user
    end

    describe "GET #new" do
      it "redirects to the homepage" do
        get :new, {}, valid_session
        expect(response).to redirect_to(root_path)
      end
    end

    describe "GET #edit" do
      it "redirects to the homepage" do
        post = Post.create! valid_attributes
        get :edit, {:id => post.to_param}, valid_session
        expect(response).to redirect_to(root_path)
      end
    end

    describe "POST #create" do
      it "does not creates a new Post" do
        expect {
          post :create, {:post => valid_attributes}, valid_session
        }.to change(Post, :count).by(0)
      end

      it "redirects to the home page" do
        post :create, {:post => valid_attributes}, valid_session
        expect(response).to redirect_to(root_path)
      end      
    end

    describe "PUT #update" do
      let(:new_attributes) {
        {title: "New", body: "Newer"}
      }

      it "does not update the requested post" do
        post = Post.create! valid_attributes
        put :update, {:id => post.to_param, :post => new_attributes}, valid_session
        post.reload
        expect(post.title).to eq("My Big Fat Greek Post")
        expect(post.body).to eq("This is a body!")
      end

      it "redirects to the home page" do
        post = Post.create! valid_attributes
        put :update, {:id => post.to_param, :post => valid_attributes}, valid_session
        expect(response).to redirect_to(root_path)
      end
    end

    describe "DELETE #destroy" do
      it "does not destroy the requested post" do
        post = Post.create! valid_attributes
        expect {
          delete :destroy, {:id => post.to_param}, valid_session
        }.to change(Post, :count).by(0)
      end

      it "redirects to the home page" do
        post = Post.create! valid_attributes
        delete :destroy, {:id => post.to_param}, valid_session
        expect(response).to redirect_to(root_url)
      end
    end
  end

  context "as an administrator" do

    let(:user) { User.create! name: "User", email: "user@site.com", password: "my-totally-secure-password", roles: [:admin] }

    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user
    end

    describe "GET #new" do
      it "assigns a new post as @post" do
        get :new, {}, valid_session
        expect(assigns(:post)).to be_a_new(Post)
      end
    end

    describe "GET #edit" do
      it "assigns the requested post as @post" do
        post = Post.create! valid_attributes
        get :edit, {:id => post.to_param}, valid_session
        expect(assigns(:post)).to eq(post)
      end
    end

    describe "POST #create" do
      context "with valid params" do
        context "when saving" do
          it "creates a new Post" do
            expect {
              post :create, {:post => valid_attributes}, valid_session
            }.to change(Post, :count).by(1)
          end

          it "assigns a newly created post as @post" do
            post :create, {:post => valid_attributes}, valid_session
            expect(assigns(:post)).to be_a(Post)
            expect(assigns(:post)).to be_persisted
          end

          it "redirects to the created post" do
            post :create, {:post => valid_attributes}, valid_session
            expect(response).to redirect_to(Post.last)
          end
      
          it "sets the posts creator to the current user" do
            post :create, {:post => valid_attributes}, valid_session
            expect(Post.last.author).to eq(user)      
          end
        end
        context "when previewing" do
          it "does not create a new Post" do
            expect {
              post :create, {:post => valid_attributes, :preview => true}, valid_session
            }.to change(Post, :count).by(0)            
          end
          it "re-renders the 'new' template" do
            post :create, {:post => valid_attributes, :preview => true}, valid_session
            expect(response).to render_template("new")
          end
        end
      end

      context "with invalid params" do
        it "assigns a newly created but unsaved post as @post" do
          post :create, {:post => invalid_attributes}, valid_session
          expect(assigns(:post)).to be_a_new(Post)
        end

        it "re-renders the 'new' template" do
          post :create, {:post => invalid_attributes}, valid_session
          expect(response).to render_template("new")
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) {
          {title: "New", body: "Newer"}
        }

        it "updates the requested post" do
          post = Post.create! valid_attributes
          put :update, {:id => post.to_param, :post => new_attributes}, valid_session
          post.reload
          expect(post.title).to eq("New")
          expect(post.body).to eq("Newer")
        end

        it "assigns the requested post as @post" do
          post = Post.create! valid_attributes
          put :update, {:id => post.to_param, :post => valid_attributes}, valid_session
          expect(assigns(:post)).to eq(post)
        end

        it "redirects to the post" do
          post = Post.create! valid_attributes
          put :update, {:id => post.to_param, :post => valid_attributes}, valid_session
          expect(response).to redirect_to(post)
        end
      end

      context "with invalid params" do
        it "assigns the post as @post" do
          post = Post.create! valid_attributes
          put :update, {:id => post.to_param, :post => invalid_attributes}, valid_session
          expect(assigns(:post)).to eq(post)
        end

        it "re-renders the 'edit' template" do
          post = Post.create! valid_attributes
          put :update, {:id => post.to_param, :post => invalid_attributes}, valid_session
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE #destroy" do
      it "destroys the requested post" do
        post = Post.create! valid_attributes
        expect {
          delete :destroy, {:id => post.to_param}, valid_session
        }.to change(Post, :count).by(-1)
      end

      it "destroys the requested post if it has tags" do
        post = Post.create! valid_attributes
        post.tags << Tag.create(name: 'aTAG!')
        expect {
          delete :destroy, {:id => post.to_param}, valid_session
        }.to change(Post, :count).by(-1)
      end

      it "redirects to the posts list" do
        post = Post.create! valid_attributes
        delete :destroy, {:id => post.to_param}, valid_session
        expect(response).to redirect_to(posts_url)
      end
    end
  end
end
