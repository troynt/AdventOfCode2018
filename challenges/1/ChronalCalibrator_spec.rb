require_relative "./ChronalCalibrator"




describe("ChronalCalibrator") do
  def assert_data(file_path, runs, result)
    cur_dir = File.dirname(__FILE__)
    chronal_calibrator = ChronalCalibrator.new File.join(cur_dir,file_path)

    expect(chronal_calibrator.calc(runs)).to eq(result)
  end

  it "should be able to handle example data" do

    assert_data("fixtures/input.txt", 1, 538)
    assert_data("fixtures/input.txt", 1000, 77271)


  end
end