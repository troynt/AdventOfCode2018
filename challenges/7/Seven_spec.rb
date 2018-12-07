require_relative "Seven"

describe "Seven" do
  it "should be able to parse a line" do
    expect(Seven.parse_line("Step A must be finished before step N can begin.")).to eq(["A", "N"])
  end

  it "should be able to parse file" do
    a = Seven.new File.join(File.dirname(__FILE__), "fixtures", "sample.txt")


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

  it "should be able to solve anis input" do
    a = Seven.new File.join(File.dirname(__FILE__), "fixtures", "anis.txt")

    a.calc

    expect(a.order.join("")).to eq("BETUFNVADWGPLRJOHMXKZQCISY")

  end

  it "shoudl be able to calculate time to complete letter" do
    expect(Seven.time_required("A", 0)).to eq(1)
    expect(Seven.time_required("Z", 0)).to eq(26)
  end

  it "should be able to solve sample part two" do
    a = Seven.new File.join(File.dirname(__FILE__), "fixtures", "sample.txt"), 2, 0

    expect(a.worker_pool.workers.length).to eq(2)
    expect(a.calc2).to eq(15)

  end

  it "should be able to solve input part two" do
    a = Seven.new File.join(File.dirname(__FILE__), "fixtures", "input.txt"), 5, 60

    expect(a.worker_pool.workers.length).to eq(5)
    expect(a.calc2).to eq(1105)

  end

  
end