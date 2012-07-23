# -*- coding: utf-8 -*-

class Object
  # サブクラスの配列を返す
  def self.subclasses
    unless @subclasses
      @subclasses = []
      Class.constants.each {|name|
        klass = Object.const_get(name)
        if klass.is_a?(Class) && klass != self && klass.ancestors.include?(self)
          @subclasses << klass
        end
      }
    end
    @subclasses
  end
  # to_fした結果が少数の場合はFloat、そうでない場合はIntegerを返す
  def to_num
     return nil if nil?
     to_f % 1 != 0 ? to_f : to_i
  end
  # 文字列が空、またはnilならtrue
  def empty?
    to_s.empty?
  end
  # empty?の反対
  def fill?
    ! empty?
  end
  # クラスパラメータ
  @@params = {}
  def self.params
    unless @@params[self]
      @@params[self] = {}
    end
    @@params[self]
  end
  # 配列下のすべての文字列の前後空白を削除
  def all_strip!
    if is_a?(Array)
      each { |v| v.all_strip! }
    elsif is_a?(Hash)
      each { |k, v| v.all_strip! }
    elsif is_a?(String)
      strip!
    end
  end
  # 配列下のすべての文字列をUTF-8に変換
  def all_toutf8!
    require "kconv"
    if is_a?(Array)
      each { |v| v.all_toutf8! }
    elsif is_a?(Hash)
      each { |k, v| v.all_toutf8! }
    elsif is_a?(String)
      replace(toutf8)
    end
  end
  # 半角英数字のみかどうか
  def single_bytes?
    to_s =~/^[ -~]*$/
  end
  # HTML変換
  def to_html
    to_s.gsub("&", "&amp;").
    gsub("<", "&lt;").
    gsub(">", "&gt;").
    gsub("\"", "&quat;").
    gsub("  ", " &nbsp;").
    gsub(/(\r\n|\n|\r)/, "<br />\n")
  end
  def to_html_p
    "<p>" +
    to_s.gsub("\r\n", "\n").
    gsub("\r", "\n").
    gsub("&", "&amp;").
    gsub("<", "&lt;").
    gsub(">", "&gt;").
    gsub("\"", "&quat;").
    gsub("  ", " &nbsp;").
    gsub(/\n{2,}/, "</p><p>").
    gsub(/\n+$/m, "").
    gsub(/\n/, "<br />") + "</p>"
  end
  def to_p
    "<p>" +
    to_s.gsub("\r\n", "\n").
    gsub("\r", "\n").
    gsub("  ", " &nbsp;").
    gsub(/\n{2,}/, "</p><p>").
    gsub(/\n+$/m, "").
    gsub(/\n/, "<br />") + "</p>"
  end
  # 文字列中のURLを自動リンク
  def link_url(options={})
    require 'uri'
    target = options[:target] || ''
    r = self
    URI.extract(to_s).each do |url|
      r = to_s.gsub(url, %|<a href="#{url}" target="#{target}">#{url}</a>|)
    end
    r
  end
  # HTML→plain変換
  def to_plain
    to_s.gsub(/<br\s?.*?>/i, "\n")
  end
  # 全角に変換
  def to_mbytes
    to_s.tr('a-zA-Z0-9 !"#$%&()*+,-./:;<=>?@[\]^_`{|}~',
      'ａ-ｚＡ-Ｚ０-９　！”＃＄％＆（）＊＋，－．／：；＜＝＞？＠［￥］＾＿｀｛｜｝～')
  end
  # 半角に変換
  def to_sbytes
    to_s.tr('ａ-ｚＡ-Ｚ０-９　！”＃＄％＆（）＊＋，－．／：；＜＝＞？＠［￥］＾＿｀｛｜｝～',
      'a-zA-Z0-9 !"#$%&()*+,-./:;<=>?@[\]^_`{|}~')
  end
  #デフォルトロガー
  def logger
    require "logger"
    Logger.new(STDOUT)
  end
end

class String
  # 指定文字数で切る
  def truncstr(n=80)
    str = self[/.{#{n}}/um]
    if str && str.size < self.size
      str += "..."
    else
      str = self
    end
    str
  end
end

class Time
  # YYYYMMDDHHMMSSというIntegerに変換
  def serial
    strftime("%Y%m%d%H%M%S").to_i
  end
  # YYYYMMDDというIntegerに変換
  def serial_date
    strftime("%Y%m%d").to_i
  end
  # Dateに変換
  def to_date
    Date.new(year, mon, mday)
  end
  # 曜日を英語短縮形で取得
  def wday_en
    to_date.wday_en
  end
  # 曜日を英語短縮形で取得（HTML）
  def wday_en_html
    to_date.wday_en_html
  end
  # 曜日を日本語で取得
  def wday_ja
    to_date.wday_ja
  end
  # 曜日を日本語で取得（HTML）
  def wday_ja_html
    to_date.wday_ja_html
  end
end

class Date
  # 曜日を英語短縮形で取得
  def wday_en
    wdays_en = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    wdays_en[wday]
  end
  # 曜日を日本語で取得（HTML）
  def wday_en_html
    wdays_en = [
      '<span class="sunday">Sun</span>',
      '<span class="monday">Mon</span>',
      '<span class="tuesday">Tue/span>',
      '<span class="wednesday">Wed</span>',
      '<span class="thursday">Thu</span>',
      '<span class="friday">Fri</span>',
      '<span class="saturday">Sat</span>',
    ]
    wdays_en[wday]
  end
  # 曜日を日本語で取得
  def wday_ja
    wdays_ja = ["日", "月", "火", "水", "木", "金", "土"]
    wdays_ja[wday]
  end
  # 曜日を日本語で取得（HTML）
  def wday_ja_html
    wdays_ja = [
      '<span class="sunday">日</span>',
      '<span class="monday">月</span>',
      '<span class="tuesday">火/span>',
      '<span class="wednesday">水</span>',
      '<span class="thursday">木</span>',
      '<span class="friday">金</span>',
      '<span class="saturday">土</span>',
    ]
    wdays_ja[wday]
  end
  # 年齢計算
  def age(calcDay = Time.now)
    age = calcDay.year - self.year
    return age -1 if calcDay.month < self.month
    return age -1 if calcDay.month == self.month && calcDay.day < self.day
    return age
  end
end

class Numeric
  # 3桁ごとにカンマを入れた文字列を返す
  def camma
    numstr = to_s
    int, frac = *numstr.split(".")
    int = int.gsub(/(\d)(?=\d{3}+$)/, '\1,')
    int << "." << frac if frac.to_i > 0
    int
  end
  # HH:mm'ss"という書式で時間を表す
  def to_timespan_s(enable_second=true)
    s = ""
    s += sprintf("%d:", self.to_i / 3600) if self.to_i / 3600 > 0
    s += sprintf("%02d'", (self.to_i % 3600) / 60)
    s += sprintf("%02d\"", self.to_i % 60) if enable_second
    s
  end
end

class Float
  # 四捨五入
  def roundoff(d=0)
    x = 10**d
    if self < 0
      (self * x - 0.5).ceil.quo(x).to_f
    else
      (self * x + 0.5).floor.quo(x).to_f
    end
  end
end

class Integer
  # YYYYMMDDHHMMSSという値をTimeに変換
  def to_time_local
    ary = to_s.scanf("%04d%02d%02d%02d%02d%02d")
    Time.local(*ary)
  end
end

class Dir
  # pathにchdirしてからglob
  def self.glob_in(pattern, path, &block)
    dirs = []
    Dir.chdir(path) {
      dirs = Dir.glob(pattern).collect! {|item| path + "/" + item}
    }
    if block_given?
      dirs.each { |dir| block.call(dir) }
    end
    dirs
  end
end

class Exception
  # 詳細メッセージ
  def description
    msg = "#{self.message} (#{self.class})\n"
    if self.backtrace
      self.backtrace.each do |s|
        msg << "    from #{s}\n"
      end
    end
    msg
  end
end
