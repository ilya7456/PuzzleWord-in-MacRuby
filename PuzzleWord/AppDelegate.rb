#
#  AppDelegate.rb
#  PuzzleWord
#
#  Created by Ilya Pozdneev on 6/26/13.
#  Copyright 2013 Ilya Pozdneev. All rights reserved.
#
require 'rubygems'
require 'csv'

class AppDelegate
    attr_accessor :window, :text_field, :label, :defenition
    def applicationDidFinishLaunching(a_notification)
        # Insert code here to initialize your application
    end
    
    def awakeFromNib
        @answer = []
        @guess
        @sample_words = []
        @a_word
        importCSV(true)
        new_word(true)
    end
    
    def new_word(sender)
        i = rand(@sample_words.size)
        @a_word = []
        @answer = @sample_words[i]
        
        if @answer[0].include? " "
            @answer[0].gsub!(" ", "")
        end
        
        if @answer[2].include? @answer[0].to_s
            @answer[2].gsub!(@answer[0].to_s, "***")
        end
        
        #puts @answer
        
        @answer[0].split(//).length.times do
            @a_word.push("_.")
        end
        
        print_word
        showDefenition(true)
    end
    
    def submit(sender)
        @guess = @text_field.stringValue
        if @answer[0].include?(@guess)
            reveal(@guess)
        else
            puts 'nope'
        end
        @text_field.stringValue = ""
    end
    
    def reveal(guess)
        answer_array = @answer[0].split(//)
        guess = guess.split(//) unless guess.length == 1
        if guess.length > 1
            answer_array.each_with_index do |item, index|
                guess.each do |letter|
                    if letter == item
                        @a_word[index] = item
                    end
                end
            end
        else
            answer_array.each_with_index do |item, index|
                if guess == item
                    @a_word[index] = item
                end
            end
        end
        print_word
    end
    
    def print_word
        @label.stringValue = ""
        @a_word.each do |char|
            @label.stringValue += char
        end
    end
    
    def importCSV(sender)
        
        dialog = NSOpenPanel.openPanel
        dialog.canChooseFiles = true
        dialog.canChooseDirectories = false
        dialog.allowsMultipleSelection = false
        
        if dialog.runModalForDirectory(nil, file:nil) == NSOKButton
            path = dialog.filenames.first
        end
        
        if path.pathExtension != "csv"
            importCSV(true)
        end
        
        CSV.foreach(path) do |row|
            @sample_words.push(row)
        end
    end
    
    def showDefenition(sender)
        @defenition.stringValue = @answer[2]
    end
end

