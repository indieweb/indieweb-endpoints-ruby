# frozen_string_literal: true

require "irb/completion"

IRB.conf[:USE_AUTOCOMPLETE] = false
IRB.conf[:USE_PAGER] = false

def clear
  system("clear")
end
