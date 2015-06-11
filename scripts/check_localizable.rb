class Localization
  attr_reader :keys, :path, :merge_conflicts

  def initialize(path)
    @path = path
    @keys = []
    @lines = []
    @merge_conflicts = false
  end

  def read
    File.readlines(@path).each do |line|
      line = line.force_encoding("utf-8")
      trimmed = line.strip
      next if trimmed.length == 0

      if trimmed.length > 6 && trimmed[0...6].eql?('<<<<<<')
        @merge_conflicts = true
        break
      end

      @lines << trimmed
      atoms = trimmed.split('=')
      key = atoms[0].strip

      puts "warning: Duplicate key #{key} in #{@path}" and next if @keys.include?(key)

      @keys << key
    end
  end

  def order_lines
    @lines.sort!
  end

  def write
    content = ''
    last_key = key_from_line(@lines[0])

    @lines.each do |line|
      key = key_from_line(line)
      unless last_key.eql?(key)
        last_key = key
        content << "\n"
      end

      content << "#{line}\n"
    end

    File.open(@path, 'w') { |f| f.write(content) }
  end

  def key_from_line(line)
    atoms = line.split('.')
    atoms[0].strip
  end
end

class LocalizationChecker
  def initialize(base_path)
    @base_path = base_path
  end

  def execute
    start_time = Time.now
    localizations = Dir["#{@base_path}/*.lproj/Localizable.strings"]
    puts "Found #{localizations.length} localizations"

    locs = []

    conflicts = false

    localizations.each do |l|
      loc = Localization.new(l)
      locs << loc
      loc.read

      next unless loc.merge_conflicts

      puts "warning: Found merge conflict in #{l}. Will not continue with that file."
      conflicts = true
    end

    if conflicts
      puts 'warning: Had merge conflicts in localization files'
      return
    end

    all_keys = []
    locs.each do |l|
      l.order_lines
      l.write
      all_keys = all_keys | l.keys
    end

    puts "Have #{all_keys.count} keys total"

    locs.each do |l|
      remaining = all_keys - l.keys
      next if remaining.length == 0

      puts "warning: #{l.path} is missing values for - #{remaining.join(',')}"
    end

    puts "Execution time #{Time.now - start_time}"
  end
end

if ARGV.length != 1
  puts 'Usage: check_localizable <path to folder containing *.lproj folders>'
  exit(0)
end

checker = LocalizationChecker.new(ARGV[0])
checker.execute
