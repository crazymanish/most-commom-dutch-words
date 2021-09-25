private_lane :get_random_dutch_words_message do |options|
  random_dutch_words = get_random_dutch_words(options)

  dutch_words_messages = []
  dutch_words_messages.append(format_dutch_word_message(number: "een", word_info: random_dutch_words[0]))
  dutch_words_messages.append(format_dutch_word_message(number: "twee", word_info: random_dutch_words[1]))
  dutch_words_messages.append(format_dutch_word_message(number: "drie", word_info: random_dutch_words[2]))
  dutch_words_messages.append(format_dutch_word_message(number: "vier", word_info: random_dutch_words[3]))
  dutch_words_messages.append(format_dutch_word_message(number: "vijf", word_info: random_dutch_words[4]))
  dutch_words_messages.join("\n")
end

private_lane :get_random_dutch_words do |options|
  require 'csv'

  random_words_count = options[:random_words_count].to_i
  csv_file_path = get_dutch_words_csv_file_path(options)
  all_words = CSV.foreach(csv_file_path, headers: true).map { |row| row.to_h }
  all_words.sample(random_words_count)
end

private_lane :get_dutch_words_csv_file_path do |options|
  file_name = options[:csv_file_name]
  repo_path = sh("git rev-parse --show-toplevel").strip
  file_paths = Dir[File.expand_path(File.join(repo_path, "**/#{file_name}"))]
  file_paths.first
end

private_lane :format_dutch_word_message do |options|
  number = options[:number]
  word_info = options[:word_info]
  dutch_word = word_info["DUTCH"]
  dutch_word_url = "https://forvo.com/search/#{dutch_word}"

  "• <#{dutch_word_url}|#{dutch_word}>: (#{word_info["ENGLISH"]})"
end

private_lane :get_random_greeting_message do |options|
  greeting_type = options[:greeting_type]
  messages = all_greeting_messages
  greeting_message = messages[greeting_type].sample
  suffix = messages["suffix"].sample
  emoji_list = ["🤗", "😈", "😇", "😊", "😍", "🙂", "☺️", "😺", "😸", "😻", "🐱", "🙌🏻", "🤟🏻", "🦋", "🦄", "☕️", "🍵", "🍸", "🍹"]

  greeting_message.concat(" #{suffix}")
  greeting_message.concat(" #{emoji_list.sample}")
  greeting_message
end

private_lane :get_random_footer_message do
  messages = all_greeting_messages
  footer_message = messages["footer"].sample
  emoji_list = [":dinosaurs:", ":happy_yes:", ":fistbump:", ":dinosaurs:", ":happy_yes:", ":bi_pride:", ":aroace_pride:", ":dinosaurs:", ":happy_yes:", ":aromantic_pride:"]

  footer_message.concat(" #{emoji_list.sample}")
  footer_message
end

private_lane :all_greeting_messages do
  require 'yaml'

  file_name = "greeting-messages.yml"
  file_path = File.expand_path("#{file_name}", File.dirname(__FILE__))
  YAML.load_file(file_path)
end
