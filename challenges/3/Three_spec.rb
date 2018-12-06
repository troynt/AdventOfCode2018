require_relative "./Three"

describe "Claim" do
  it "should be able to init from string" do
    claim = Claim.init_from_str("#123 @ 3,2: 5x4")

    expect(claim.id).to eq("123")
    expect(claim.x).to eq(3)
    expect(claim.y).to eq(2)

    expect(claim.w).to eq(5)
    expect(claim.h).to eq(4)

    # expect(claim.to_squares).to eq([[4, 3], [1, 2]])

  end
end


describe "Three" do
  def assert_data(file_path, result)
    cur_dir = File.dirname(__FILE__)
    three = Three.new File.join(cur_dir,file_path)
    expect(three.calc).to eq(result)
  end

  def assert_data2(file_path, result)
    cur_dir = File.dirname(__FILE__)
    three = Three.new File.join(cur_dir,file_path)
    expect(three.calc2).to eq(result)
  end

  it "should be able to test overlap" do
    cur_dir = File.dirname(__FILE__)
    three = Three.new File.join(cur_dir,"fixtures/sample.txt")
    claim_three = three.claims.find { |x| x.id == "3" }
    claim_one = three.claims.find { |x| x.id == "1" }
    expect(claim_one.overlaps?(claim_three)).to eq(false)
  end


  it "should be able to split chars" do
    assert_data("fixtures/sample.txt", 4)

  end

  it "should be able to complete challenge" do
    assert_data("fixtures/input.txt", 109143)
  end


  it "should be able to complete part 2 with sample" do
    assert_data2("fixtures/sample.txt", "3")
  end

  it "should be able to complete part 2 with input" do
    assert_data2("fixtures/input.txt", "506")
  end

end