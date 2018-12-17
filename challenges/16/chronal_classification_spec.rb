
require_relative 'chronal_classification'

require 'pry'



describe 'ChronalClassification' do
  def get_data(file_path)
    File.open(File.join(File.dirname(__FILE__), file_path))
  end

  it "should be able to handle sample" do
    c = ChronalClassification.new(get_data("fixtures/sample2.txt"))

    expect(c.samples.length).to eq(4)

    c.compile
  end

  it "should be able to handle input and program" do
    c = ChronalClassification.new(get_data("fixtures/input.txt"))

    c.compile

    expect(c.ambiguous_sample_count).to eq(521)

    r = c.execute(get_data("fixtures/program.txt"))

    expect(r).to eq([594, 3, 4, 594])


  end

end
#