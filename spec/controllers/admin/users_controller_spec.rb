require 'rails_helper'

describe Admin::UsersController do

  let :valid_attributes do
    {
      name: "Billy",
      email: "billy@bob.com",
      password: "mypassword",
    }
  end

  let :invalid_attributes do
    {
      name: "",
    }
  end

  let :valid_session do
    {}
  end

  let(:user) { User.create! valid_attributes }

  describe "GET #index" do
    it "assigns all users as @users" do
      get :index, {}, valid_session
      expect(assigns(:users)).to eq([user])
    end
  end

  describe "GET #edit" do
    it "assigns the requested user as @user" do
      get :edit, {:id => user.to_param}, valid_session
      expect(assigns(:user)).to eq(user)
    end
  end

  describe "PUT #update" do
    
    context "with valid params" do
      let(:new_attributes) {
        {
          name: "Newer",
          password: "",
        }
      }

      before do
        put :update, { :id => user.to_param, :user => new_attributes }, valid_session
      end

      it "updates the requested user" do
        user.reload
        expect(user.name).to eq("Newer")
      end

      it "assigns the requested user as @user" do
        expect(assigns(:user)).to eq(user)
      end

      it "redirects to the index" do
        expect(response).to redirect_to([:admin, :users])
      end
    end

    context "with invalid params" do

      before do
        put :update, {:id => user.to_param, :user => invalid_attributes}, valid_session
      end
      it "assigns the user as @user" do
        expect(assigns(:user)).to eq(user)
      end

      it "re-renders the 'edit' template" do
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested post" do
      user
      expect {
        delete :destroy, {:id => user.to_param}, valid_session
      }.to change(User, :count).by(-1)
    end

    it "redirects to the users list" do
      delete :destroy, {:id => user.to_param}, valid_session
      expect(response).to redirect_to([:admin, :users])
    end
  end

end
