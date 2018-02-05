class Hebburn
  def initialize(tree = {})
    @tree = tree
  end

  def self.to_hiragana

  end

  def self.to_romaji

  end

  def self.to_katakana

  end
  @@hiragana = Hebburn.new({'a' => 'あ', 'i' => 'い', 'u' => 'う', 'e' => 'え', 'o' => 'お',
                            'k' => Hebburn.new({'a' => 'か', 'i' => 'き', 'u'  => 'く', 'e' => 'け', 'e' => 'こ',
                                          'y' => Hebburn.new({'a' => 'きゃ', 'u' => 'きゅ', 'o' => 'きょ'})}),
                            'g' => Hebburn.new({'a' => 'が', 'i' => 'ぎ', 'u' => 'ぐ', 'e' => 'げ', 'o' => 'ご',
                                          'y' => Hebburn.new({'a' => 'ぎゃ', 'u' => 'ぎゅ', 'o' => 'ぎょ'})}),
                            's' => Hebburn.new({'a' => 'さ', 'u' => 'す', 'e' => 'せ', 'o' => 'そ',
                                          'h' => Hebburn.new({'a' => 'しゃ', 'i' => 'し', 'u' => 'しゅ', 'o' => 'しょ'})}),
                            'z' => Hebburn.new({'a' => 'ざ', 'u' => 'ず', 'e' => 'ぜ', 'o' => 'ぞ'}),
                            'j' => Hebburn.new({'a' => 'じゃ', 'i' => 'じ', 'u' => 'じゅ', 'o' => 'じょ'}),
                            't' => Hebburn.new({'a' => 'た', 'e' => 'て', 'o' => 'と', 's' => Hebburn.new ({'u' => 'つ'})}),
                            'd' => Hebburn.new({'a' => 'だ', 'e' => 'で', 'o' => 'ど'}),
                            'c' => Hebburn.new({'h' => Hebburn.new({'a' => 'ちゃ', 'i' => 'ち', 'u' => 'ちゅ', 'o' => 'ちょ'})})
                     })
end
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
=end