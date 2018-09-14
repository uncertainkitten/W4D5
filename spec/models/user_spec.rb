require 'rails_helper'

RSpec.describe User, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  
  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:password_digest) }
  it { should validate_presence_of(:session_token) }
  it { should validate_length_of(:password).is_at_least(8) }
  
  describe "session_token" do
    it "assigns session_token if one is not given" do
      marlene = User.new(username: 'marlene', password: 'shuffleboard')
      expect(marlene.session_token).not_to be_nil
    end
  end
  
  describe "password encryption" do
    it "does not save passwords to dee bee" do
      User.create!(username: 'marlene', password: 'shuffleboard')
      user = User.find_by(username: 'marlene')
      expect(user.password_digest).not_to be('shuffleboard')
    end
    
    it "encrypts password password using BCrypt" do
      expect(BCrypt::Password).to receive(:create).with('shuffleboard')
      User.new(username: 'marlene', password: 'shuffleboard')
    end
  end
  
  context "find User by credentials" do
    describe "with valid params" do
      let!(:user) { User.create!(username: 'marlene', password: 'shuffleboard') }
      let!(:usertwo) { User.create!(username: 'DW3bZ', password: 'starwars') }
      
      it "finds the correct user" do
        expect(User.find_by_credentials('marlene', 'shuffleboard')).to eq(User.find_by(username: 'marlene')) 
      end
    end
    
    describe "without valid params" do
      let!(:user) { User.create(username: 'marlene', password: 'shuffleboard') }
      let!(:usertwo) { User.create(username: 'DW3bZ', password: 'starwars') }
      
      it "returns nil when given invalid params" do 
        expect(User.find_by_credentials('DW3bZ', 'shuffleboard')).to be_nil
      end
    end
  end
end
