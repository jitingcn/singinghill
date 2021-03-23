class String
  def to_fullwidth
    tr("\u0021-\u007E\u0020\u0027", "\uFF01-\uFF5E\u3000\u2019")
  end
end
