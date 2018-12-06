require_relative "./InvManagerB"

# InvManagerB class was lost...
describe.skip "InvManagerB" do

  def assert_data(file_path, result)
    cur_dir = File.dirname(__FILE__)
    inv_manager = InvManagerB.new File.join(cur_dir,file_path)
    expect(inv_manager.calc).to eq(result)
  end

  it 'should be able to calculate diff counts' do
    expect(InvManagerB.diff_count(InvManagerB.parse_id("jello"), InvManagerB.parse_id("hellg"))).to eq(2)
  end


  it "should be able to calculate sample data" do
    assert_data("fixtures/day2-pt2-sample.txt", "fgij")
  end

  it "should be able to calculate challenge data" do
    assert_data("fixtures/day2-pt2.txt", "uqcidadzwtnhsljvxyobmkfyr")
  end

end