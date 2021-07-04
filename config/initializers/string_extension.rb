class String
  def to_fullwidth
    tr("\u0021-\u007E\u0020\u0027", "\uFF01-\uFF5E\u3000\u2019")
  end

  def to_halfwidth
    tr("\uFF01-\uFF5E\u3000\u2019", "\u0021-\u007E\u0020\u0027")
  end

  def warp_control
    gsub(/(?!{)((IM\d{2}|SC\d{2}|1X|VB\d{2}|CS\d{2}|#[01][ A-Za-z0-9_\-!.]+(##)?)+)/) { |w| "{#{w}}" }
  end

  def to_line
    symbol = 0
    chars.map do |char|
      symbol = 0 if char == "}" # match control symbol end
      next char if symbol == 1

      case char
      when "{"  # match control symbol start
        symbol = 1
        ""
      when "}"  # match control symbol end
        ""
      else
        char.to_fullwidth
      end
    end.join.gsub("\r\n", "CR")
  end
end
