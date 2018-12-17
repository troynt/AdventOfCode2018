# frozen_string_literal: true

class ChronalClassification
  INSTRUCTIONS = {
    addr: ->(a, b, c, r) { r[c] = r[a] + r[b] },
    addi: ->(a, b, c, r) { r[c] = r[a] + b },

    mulr: ->(a, b, c, r) { r[c] = r[a] * r[b] },
    muli: ->(a, b, c, r) { r[c] = r[a] * b },

    banr: ->(a, b, c, r) { r[c] = r[a] & r[b] },
    bani: ->(a, b, c, r) { r[c] = r[a] & b },

    borr: ->(a, b, c, r) { r[c] = r[a] | r[b] },
    bori: ->(a, b, c, r) { r[c] = r[a] | b },

    setr: ->(a, _, c, r) { r[c] = r[a] },
    seti: ->(a, _, c, r) { r[c] = a },

    gtir: ->(a, b, c, r) { r[c] = a > r[b] ? 1 : 0 },
    gtri: ->(a, b, c, r) { r[c] = r[a] > b ? 1 : 0 },
    gtrr: ->(a, b, c, r) { r[c] = r[a] > r[b] ? 1 : 0 },

    eqir: ->(a, b, c, r) { r[c] = a == r[b] ? 1 : 0 },
    eqri: ->(a, b, c, r) { r[c] = r[a] == b ? 1 : 0 },
    eqrr: ->(a, b, c, r) { r[c] = r[a] == r[b] ? 1 : 0 }
  }.freeze

  attr_reader(
    :samples,
    :ambiguous_sample_count,
    :opcode_mapping
  )

  def initialize(samples)
    reset
    @samples = []
    samples.each_slice(4) do |sample|
      @samples << parse_sample(sample.join(''))
    end
  end

  def str_to_arr(str)
    str.scan(/\d+/).map(&:to_i)
  end

  def parse_sample(sample)
    before, cur, after = sample.strip.split("\n", 3)

    {
      raw: sample,
      before: str_to_arr(before),
      instruction: str_to_arr(cur),
      after: str_to_arr(after)
    }.freeze
  end

  def execute(program)
    r = [0] * 4
    program.each do |ins|
      opcode, a, b, c = str_to_arr(ins)
      INSTRUCTIONS[opcode_mapping[opcode].first].call(a, b, c, r)
    end

    r
  end

  def reset
    @opcode_mapping = Hash.new { Set.new(INSTRUCTIONS.keys) }
    @ambiguous_sample_count = 0
  end

  def compile(verbose: false, reset_opcodes: true, max_rounds: 10)
    reset if reset_opcodes

    i = 0
    samples.each do |sample|
      before, instruction_with_params, after = sample.values_at(:before, :instruction, :after)

      i += 1
      puts "#{i}/#{samples.length}" if verbose

      opcode, a, b, c = instruction_with_params

      ins_to_check = Set.new(INSTRUCTIONS.keys)

      possible_instructions = ins_to_check.select do |ins|
        block = INSTRUCTIONS[ins]
        r = before.dup

        block.call(a, b, c, r)

        r == after
      end

      if possible_instructions.empty?
        raise "Unable to find operations for #{sample}!"
      end

      @ambiguous_sample_count += 1 if possible_instructions.size >= 3
      @opcode_mapping[opcode] &= possible_instructions
    end

    done = Set.new(opcode_mapping.select { |_k, v| v.size == 1 }.map { |_k, v| v.first })

    rounds = 0
    loop do
      rounds += 1
      @opcode_mapping.map do |opcode, v|
        v.subtract(done) if v.size > 1

        done.add(v.first) if v.size == 1

        [opcode, v]
      end

      break if opcode_mapping.all? { |_k, v| v.size == 1 }
      break if rounds > max_rounds
    end
  end
end
