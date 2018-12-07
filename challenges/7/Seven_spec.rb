require_relative "Seven"
describe "Seven" do
  it "should be able to parse a line" do
    expect(Seven.parse_line("Step A must be finished before step N can begin.")).to eq(["A", "N"])
  end

  it "should be able to parse file" do
    a = Seven.new File.join(File.dirname(__FILE__), "fixtures", "sample.txt")


    puts a.graph.inspect


  end

  it "should be able to solve sample" do
    a = Seven.new File.join(File.dirname(__FILE__), "fixtures", "sample.txt")

    a.calc

    expect(a.order.join("")).to eq("CABDFE")

  end

  it "should be able to solve input" do
    a = Seven.new File.join(File.dirname(__FILE__), "fixtures", "input.txt")

    a.calc

    expect(a.order.join("")).to eq("GLMVWXZDKOUCEJRHFAPITSBQNY")

  end

  it "shoudl be able to calculate time to complete letter" do
    expect(Seven.time_required("A")).to eq(60 + 1)
    expect(Seven.time_required("Z")).to eq(60 + 26)
  end

  skip "should be able to solve sample part two" do
    a = Seven.new File.join(File.dirname(__FILE__), "fixtures", "sample.txt")

    expect(a.calc2).to eq(2)

  end

  
end