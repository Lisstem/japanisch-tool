require 'yaml'
class Hepburn
  attr_writer :next_char
  def initialize(tree = {}, default = nil, next_char = nil)
    @tree = tree
    @next_char = next_char
    @default = default
  end

  def convert(string, index)
    if index >= string.length
      return ''
    end
    old = string[index]
    new = @tree[old]
    if new.respond_to? :convert
      new.convert(string, index + 1)
    elsif new.nil?
      if @next_char == self
        return @next_char.convert(string, index + 1).insert(0, old)
      elsif @default.nil?
        return @next_char.convert(string, index)
      else
        return @next_char.convert(string, index).insert(0, @default)
      end
    else
      @next_char.convert(string, index + 1).insert(0, new)
    end
  end

  def can_convert?(string, index)
    old = string[index]
    new = tree[old]
    if new.respond_to? :can_convert?
      new.can_convert?(string, index + 1)
    else
      old.nil?
    end
  end
  def self.to_hiragana(string)
    @@hiragana.convert(string, 0)
  end

  def self.to_romaji

  end

  def self.to_katakana

  end

  def self.hira_yaml
    puts @@hiragana.to_yaml
  end
  y = Hepburn.new({'a' => 'や', 'u' => 'ゆ', 'o' => 'よ'}, 'y')

  hhy = Hepburn.new({'a' => 'っひゃ', 'u' => 'っひゅ', 'o' => 'っひょ'}, 'hh', y)
  hh = Hepburn.new({'a' => 'っは', 'i' => 'っひ', 'u' => 'っふ', 'e' => 'っへ', 'o' => 'っほ', 'y' => hhy}, 'hh')
  hy = Hepburn.new({'a' => 'ひゃ', 'u' => 'ひゅ', 'o' => 'ひょ'}, 'h', y)
  h = Hepburn.new({'a' => 'は', 'i' => 'ひ', 'u' => 'ふ', 'e' => 'へ', 'o' => 'ほ', 'y' => hy, 'h' => hh}, 'h')
  ff = Hepburn.new({'u' => 'っふ'}, 'ff')
  f = Hepburn.new({'u' => 'ふ', 'f' => ff}, 'f')

  bby = Hepburn.new({'a' => 'っひゃ', 'u'  => 'っひゅ', 'o'  => 'っひょ'}, 'bb', y)
  bb = Hepburn.new({'a' => 'っば' , 'i' => 'っび', 'u' => 'っぶ', 'e'  => 'っべ', 'o' => 'っぼ', 'y' => bby}, 'bb')
  by = Hepburn.new({'a' => 'ひゃ', 'u'  => 'ひゅ', 'o'  => 'ひょ'}, 'b', y)
  b = Hepburn.new({'a' => 'ば' , 'i' => 'び', 'u' => 'ぶ', 'e'  => 'べ', 'o' => 'ぼ', 'y' => by, 'b' => bb}, 'b')

  ppy = Hepburn.new({'a' => 'っぴゃ', 'u' => 'っぴゅ', 'o' => 'っぴょ'}, 'pp', y)
  pp = Hepburn.new({'a' => 'っぱ', 'i' => 'っぴ', 'u' => 'っぷ', 'e' => 'っぺ', 'o' => 'っぽ', 'y' => ppy}, 'pp')
  py = Hepburn.new({'a' => 'ぴゃ', 'u' => 'ぴゅ', 'o' => 'ぴょ'}, 'p', y)
  p = Hepburn.new({'a' => 'ぱ', 'i' => 'ぴ', 'u' => 'ぷ', 'e' => 'ぺ', 'o' => 'ぽ', 'y' => py, 'p' => pp}, 'p')

  kky = Hepburn.new({'a' => 'っきゃ', 'u' => 'っきゅ', 'o' => 'っきょ'}, 'kk', y)
  kk = Hepburn.new({'a' => 'っか', 'i' => 'っき', 'u'  => 'っく', 'e' => 'っけ', 'o' => 'っこ', 'y' =>  kky}, 'kk')
  ky = Hepburn.new({'a' => 'きゃ', 'u' => 'きゅ', 'o' => 'きょ'}, 'k', y)
  k = Hepburn.new({'a' => 'か', 'i' => 'き', 'u'  => 'く', 'e' => 'け', 'o' => 'こ', 'y' =>  ky, 'k' => kk}, 'k')

  ggy = Hepburn.new({'a' => 'っぎゃ', 'u' => 'っぎゅ', 'o' => 'っぎょ'}, 'gg', y)
  gg = Hepburn.new({'a' => 'っが', 'i' => 'っぎ', 'u' => 'っぐ', 'e' => 'っげ', 'o' => 'っご', 'y' => ggy}, 'gg')
  gy = Hepburn.new({'a' => 'ぎゃ', 'u' => 'ぎゅ', 'o' => 'ぎょ'}, 'g', y)
  g = Hepburn.new({'a' => 'が', 'i' => 'ぎ', 'u' => 'ぐ', 'e' => 'げ', 'o' => 'ご', 'y' => gy, 'g' => gg}, 'g')

  ssh = Hepburn.new({'a' => 'っしゃ', 'i' => 'っし', 'u' => 'っしゅ', 'o' => 'っしょ'}, 'ss', h)
  ss = Hepburn.new({'a' => 'っさ', 'u' => 'っす', 'e' => 'っせ', 'o' => 'っそ', 'h' => ssh}, 'ss')
  sh = Hepburn.new({'a' => 'しゃ', 'i' => 'し', 'u' => 'しゅ', 'o' => 'しょ'}, 's', h)
  s = Hepburn.new({'a' => 'さ', 'u' => 'す', 'e' => 'せ', 'o' => 'そ', 'h' => sh, 's' => ss}, 's')

  zz = Hepburn.new({'a' => 'っざ', 'u' => 'っず', 'e' => 'っぜ', 'o' => 'っぞ'}, 'zz')
  z = Hepburn.new({'a' => 'ざ', 'u' => 'ず', 'e' => 'ぜ', 'o' => 'ぞ', 'z' => zz}, 'z')
  jj = Hepburn.new({'a' => 'っじゃ', 'i' => 'っじ', 'u' => 'っじゅ', 'o' => 'っじょ'}, 'jj')
  j = Hepburn.new({'a' => 'じゃ', 'i' => 'じ', 'u' => 'じゅ', 'o' => 'じょ', 'j' => jj}, 'j')

  tts = Hepburn.new({'u' => 'っつ'}, 'tt', s)
  tt = Hepburn.new({'a' => 'った', 'e' => 'って', 'o' => 'っと', 's' => tts}, 'tt')
  tch = Hepburn.new({'a' => 'っちゃ', 'i' => 'っち', 'u' => 'っちゅ', 'o' => 'っちょ'}, 'tc', h)
  tc = Hepburn.new({'h' => tch}, 'tc')
  ts = Hepburn.new({'u' => 'つ'}, 't', s)
  t = Hepburn.new({'a' => 'た', 'e' => 'て', 'o' => 'と', 's' => ts, 't' => tt, 'c' => tc}, 't')
  ch = Hepburn.new({'a' => 'ちゃ', 'i' => 'ち', 'u' => 'ちゅ', 'o' => 'ちょ'}, 'c', h)
  c = Hepburn.new({'h' => ch}, 'c')

  dd = Hepburn.new({'a' => 'っだ', 'e' => 'っで', 'o' => 'っど'}, 'dd')
  d = Hepburn.new({'a' => 'だ', 'e' => 'で', 'o' => 'ど', 'd' => dd}, 'd')

  ny = Hepburn.new({'a' => 'にゃ', 'u' => 'にゅ' , 'o' => 'にょ'}, 'ん', y)
  n = Hepburn.new({'a' => 'な', 'i' => 'に', 'u' => 'ぬ', 'e'=> 'ね', 'o' => 'の', 'y' => ny}, 'ん')

  my = Hepburn.new({'a' => 'みゃ', 'u' => 'みゅ', 'o' => 'みょ'}, 'm', y)
  m = Hepburn.new({'a' => 'ま', 'i' => 'み', 'u' => 'む', 'e' => 'め', 'o' => 'も', 'y' => my}, 'm')

  ry = Hepburn.new({'a' => 'みゃ', 'u' => 'みゅ', 'o' => 'みょ'}, 'r', y)
  r = Hepburn.new({'a' => 'ら', 'i' => 'り', 'u' => 'る', 'e' => 'れ', 'o' => 'ろ', 'y' => ry}, 'r')

  w = Hepburn.new({'a' => 'わ', 'o' => 'を'}, 'w')

  @@hiragana = Hepburn.new({'a' => 'あ', 'i' => 'い', 'u' => 'う', 'e' => 'え', 'o' => 'お',
                            'k' => k, 'g' => g, 's' => s, 'z' => z, 'j' => j, 't' => t, 'd' => d, 'c' => c, 'n' => n,
                            'h' => h, 'f' => f, 'b' => b, 'p' => p, 'm' => m, 'r' => r, 'y' => y, 'w' => w})
  blub = [y, hh, h, ff, f, bb, b, pp, p, kk, k, gg, g, ss, s, zz, z, jj, j, tt, tc, t, c, dd, d,  n, m, r ,w, @@hiragana]
  blub.each do |hepburn|
    hepburn.next_char = @@hiragana
  end
end
#puts Hepburn.hira_yaml

=begin
a i u e o
ka ki ku ke ko kya kyu kyo
ga gi gu ge go gya gyu gyo
sa shi su se so sha shu sho
za ji zu ze zo ja ju jo
ta chi tsu te to cha chu cho
da ji zu de do ja ji jo
na ni nu ne no nya nyu nyo n
ha hi fu he ho hya hyu hyo
ba bi bu be bo bya byu byo
pa pi pu pe po pya pyu pyo
ma mi mu me mo mya myu myo
ya    ya    yo
ra ri ru re ro rya ryu ryo
wa          wo
=end