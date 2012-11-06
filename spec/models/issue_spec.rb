require 'spec_helper'

describe "Issue Model" do
  let(:issue) { Issue.new }
  it 'can be created' do
    issue.should_not be_nil
  end
end
