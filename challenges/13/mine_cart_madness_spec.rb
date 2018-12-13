
require_relative 'mine_cart_madness'

describe 'MineCartMadness' do
  def get_data(file_path)
    File.open(File.join(File.dirname(__FILE__),file_path)).readlines.join("")
  end


  it 'should be able to connect tracks' do
    m = MineCartMadness.new("""||/-\\
v|| |
||\\-/
||
||
^|
||
""")

    # first column
    expect(m.tracks[1][0].down).to eq(m.tracks[2][0])
    expect(m.tracks[2][0].up).to eq(m.tracks[1][0])

    # second column
    expect(m.tracks[1][1].right).to eq(nil)
    expect(m.tracks[1][1].down).to eq(m.tracks[2][1])
    expect(m.tracks[2][1].up).to eq(m.tracks[1][1])
    expect(m.tracks[1][1].left).to eq(nil)

    # third column
    expect(m.tracks[0][2].left).to eq(nil)
    expect(m.tracks[1][2].left).to eq(nil)
    expect(m.tracks[1][2].right).to eq(m.tracks[1][3])
    expect(m.tracks[1][2].down).to eq(m.tracks[2][2])



  end

  # this wasn't needed
  skip "should be able to identify intersections" do

    m = MineCartMadness.new("""    |
    |
 ---v---
    |
    |""")
    
    expect(m.tracks[2][4].type).to eq(:inter)
  end


  it "should be able to turn" do

    puts
    m = MineCartMadness.new("""/-\\
v |
\\-/
""")

    # expect(m.tracks[2][0].right).to eq(m.tracks[2][1])
    13.times do
      m.tick
    end

    expect(m.carts[0].x).to eq(2)
    expect(m.carts[0].y).to eq(0)
    
  end

  it 'should be able to crash' do

    m = MineCartMadness.new("""|
v
|
|
|
^
|
""")

    crashed = false
    loop do
      m.tick
    rescue MineCartCrashException => e
      # m.draw
      # puts "Crash at #{e.track.y}, #{e.track.x} with #{e.cart.id} and #{e.track.contains.id}!"
      expect(e.track.y).to eq(3)
      expect(e.track.x).to eq(0)
      crashed = true
      break
    end
    expect(crashed).to eq(true)
  end

  it 'should be able to handle sample' do
    m = MineCartMadness.new(get_data("fixtures/sample.txt"))

    crashed = false
    expect(m.carts.length).to eq(2)
    15.times do
      m.tick

    rescue MineCartCrashException => e
      crashed = true
      #puts "Crash at #{e.track.x},#{e.track.y} with Carts #{e.cart.id} and #{e.track.contains.id}!"
      expect(e.track.x).to eq(7)
      expect(e.track.y).to eq(3)
      break
    end

    expect(crashed).to eq(true)

  end

  it 'sort test' do
    Pt = Struct.new(:x, :y)

    arr = [Pt.new(2,1), Pt.new(0,2), Pt.new(0,1), Pt.new(-1,1)]
    expected = [Pt.new(-1,1), Pt.new(0,1), Pt.new(2,1), Pt.new(0,2)]
    sorted = arr.sort {|a, b| [a.y, a.x] <=> [b.y, b.x] }

    expect(sorted).to eq(expected)
  end

  it 'should be able to handle wtf case' do
    m = MineCartMadness.new(get_data("fixtures/wtf.txt"))

    5.times do
      m.tick
    end
    # m.draw

    #expect(m.tracks[1][2].right).to eq(nil)
    #expect(m.tracks[1][3].left).to eq(nil)

    #expect(m.carts.first.x).to eq(3)
    #expect(m.carts.first.y).to eq(0)

  end

  it 'should be able to handle puzzle' do
    m = MineCartMadness.new(get_data("fixtures/input.txt"))

    #system("clear")
    #m.draw
    #gets.chomp

    loop do
      #system("clear")
      #m.draw
      #gets.chomp
      m.tick

    rescue MineCartCrashException => e
      # m.draw
      # puts "Crash at #{e.track.x},#{e.track.y} with Carts #{e.cart.id} and #{e.track.contains.id}!"
      break
    end

  end

  it 'should be able to handle sample 2' do
    m = MineCartMadness.new(get_data("fixtures/sample2.txt"))
    loop do
      m.tick_and_clean
      break if m.carts.length == 1
    end

    final_cart = m.carts.first

    expect([final_cart.x, final_cart.y]).to eq([6, 4])

  end

  it 'should be able to handle input 2 for part 2' do
    m = MineCartMadness.new(get_data("fixtures/input2.txt"))
    expect(m.carts.length % 2).to eq(1)
    loop do

      m.tick_and_clean do

        #m.clear_draw
        #gets
      end


      break if m.carts.length == 1
    end

    final_cart = m.carts.first
    expect([final_cart.x, final_cart.y]).to eq([73, 36])

  end



  it 'should be able to handle input for part 2' do
    m = MineCartMadness.new(get_data("fixtures/input.txt"))
    expect(m.carts.length % 2).to eq(1)
    loop do

      m.tick_and_clean do

        #m.clear_draw
        #gets
      end


      break if m.carts.length == 1
    end

    final_cart = m.carts.first
    expect([final_cart.x, final_cart.y]).to eq([68, 27])

  end
end
