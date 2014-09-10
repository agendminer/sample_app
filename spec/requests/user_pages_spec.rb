require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
    describe "has avatar" do
      it { should have_selector('img', 'gravatar') }
    end
    describe "avatar is sizable" do
      let (:avatar) { page.find('img', 'gravatar') }
      specify { expect(avatar).to_not be_nil }
      #specify {expect(avatar).to_not nil?}
      specify { expect(avatar['src']).to include('?s=50') }
      #specify {expect (avatar).to respond_to?(:size)}
    end
  end

  describe "signup page" do
    before { visit signup_path }

    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }


  end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
      it "should show errors" do
        click_button submit

        should have_selector('#error_explanation')
      end
      describe "after submission" do
        before { click_button submit }

        it { should have_title('Sign up') }
        it { should have_content('error') }
      end

    end

    describe "with valid information" do
      before do
        fill_in "Name", with: "Example User"
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
      it "should show greetings" do
        click_button submit
        should have_selector('div', 'alert-success')
        #it should have_selector('div', :class => "alert-success")
      end
      describe "with valid information" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_title(user.name) }

        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_link('Sign out') }
        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end
    end
  end

end
