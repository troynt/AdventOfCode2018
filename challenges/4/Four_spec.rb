require 'time'
require_relative "./Four"

describe "LogEntry" do
  it "should be able to parse a date" do
    e = LogEntry.new("[1518-11-01 00:00] Guard #10 begins shift")

    expect(e.time).to eq(Time.new(1518, 11, 1, 0,0,0,0))
  end

  it "should be able to find guard id" do
    e = LogEntry.new("[1518-11-01 00:00] Guard #10 begins shift")

    expect(e.guard_id).to eq(10)

    e2 = LogEntry.new("[1518-11-01 00:00] begins shift")
    expect(e2.guard_id).to eq(nil)

  end

  it "should be able to find state" do
    e = LogEntry.new("[1518-11-01 00:00] Guard #10 begins shift")

    expect(e.state).to eq("awake")

    e2 = LogEntry.new("[1518-11-01 00:00] Guard #10 falls asleep")

    expect(e2.state).to eq("sleeping")


  end
end

describe "Four" do
  CUR_DIR = File.dirname(__FILE__)
  def assert_data(file_path, result)
    
    three = Four.new File.join(CUR_DIR,file_path)
    expect(three.calc).to eq(result)
    three
  end

  def assert_data2(file_path, result)
    
    three = Four.new File.join(CUR_DIR,file_path)
    expect(three.calc2).to eq(result)
    three
  end

  it "should be able to calculate sample data" do
    four = assert_data("fixtures/sample.txt", 240)

    expect(four.guards.keys).to eq([10, 99])
    expect(four.guards[10].time_sleeping).to eq(50)
    expect(four.guards[99].time_sleeping).to eq(30)
  end

  it "should be able to calculate input data" do
    assert_data("fixtures/part-a.txt", 87681)
  end


  it "should be able to calculate sample input data part 2" do
    assert_data2("fixtures/sample.txt", 4455)
  end

  it "should be able to calculate input data part 2" do
    assert_data2("fixtures/part-a.txt", 136461)
  end



end