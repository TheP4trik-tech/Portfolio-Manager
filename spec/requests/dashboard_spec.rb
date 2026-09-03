require 'rails_helper'
RSpec.describe 'Dashboard', type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  it "load root page " do
    get root_path
    expect(response).to have_http_status(:ok)
  end
end
