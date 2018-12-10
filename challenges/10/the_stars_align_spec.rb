
require_relative 'the_stars_align'

describe 'TheStarsAlign' do
  def get_stars(file_path)
    File.open(File.join(File.dirname(__FILE__),file_path)).readlines.map {|x| Star.init_from_str(x)}
  end

  it "should be able to calculate sample data" do
    stars = get_stars("fixtures/sample.txt")

    s = TheStarsAlign.new(stars)

    s.step_until_aligned

    s.draw
    expect(1).to eq(1)
  end


  it "should be able to calculate puzzle data" do
    stars = get_stars("fixtures/input.txt")

    s = TheStarsAlign.new(stars)

    steps_needed = s.step_until_aligned

    s.draw
    expect(steps_needed).to eq(10521)
  end

end
