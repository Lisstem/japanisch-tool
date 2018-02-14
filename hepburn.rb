require 'yaml'
#TODO documentation
class Hepburn
  attr_writer :next_char
  def initialize(tree = {}, next_char = nil, default = nil)
    @tree = tree
    @next_char = next_char
    @default = default
  end

  #TODO implement iterative method
  def convert(string, index, default)
    if index >= string.length
      return ''
    end
    old = string[index]
    new = @tree[old]
    if new.respond_to? :convert
      new.convert(string, index + 1, default)
    elsif new.nil?
      if @next_char == self
        return @next_char.convert(string, index + 1, default).insert(0, old)
      elsif @default.nil?
        return @next_char.convert(string, index, default)
      else
        return @next_char.convert(string, index, default).insert(0, @default)
      end
    else
      default.convert(string, index + 1, default).insert(0, new)
    end
  end

  def self.to_hiragana(string)
    @hiragana.convert(string.downcase, 0, @hiragana)
  end

  def self.to_romaji(string)
    @romaji.convert(string, 0, @romaji)
  end

  def self.to_katakana(string)
    copy = string.downcase
    copy.gsub!('aa', 'aー')
    copy.gsub!('ii', 'iー')
    copy.gsub!('uu', 'uー')
    copy.gsub!('ee', 'eー')
    copy.gsub!('oo', 'oー')
    copy.gsub!('ou', 'oー')
    @katakana.convert(copy, 0, @katakana)
  end

  def self.hira_yaml
    puts @hiragana.to_yaml
  end

  def self.romaji_yaml
    puts @romaji.to_yaml
  end

  def self.kata_yaml
    puts @katakana.to_yaml
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

  ry = Hepburn.new({'a' => 'りゃ', 'u' => 'りゅ', 'o' => 'りょ'}, 'r', y)
  r = Hepburn.new({'a' => 'ら', 'i' => 'り', 'u' => 'る', 'e' => 'れ', 'o' => 'ろ', 'y' => ry}, 'r')

  w = Hepburn.new({'a' => 'わ', 'o' => 'を'}, 'w')

  @hiragana = Hepburn.new({'a' => 'あ', 'i' => 'い', 'u' => 'う', 'e' => 'え', 'o' => 'お', ',' => '、', '.' => '。',
                            'k' => k, 'g' => g, 's' => s, 'z' => z, 'j' => j, 't' => t, 'd' => d, 'c' => c, 'n' => n,
                            'h' => h, 'f' => f, 'b' => b, 'p' => p, 'm' => m, 'r' => r, 'y' => y, 'w' => w})
  blub = [y, hh, h, ff, f, bb, b, pp, p, kk, k, gg, g, ss, s, zz, z, jj, j, tt, tc, t, c, dd, d,  n, m, r ,w, @hiragana]
  blub.each do |hepburn|
    hepburn.next_char = @hiragana
  end


  ki = Hepburn.new({'ゃ' => 'kya', 'ゅ' => 'kyu', 'ょ' => 'kyo'}, 'ki')
  gi = Hepburn.new({'ゃ' => 'gya', 'ゅ' => 'gyu', 'ょ' => 'gyo'}, 'gi')
  shi = Hepburn.new({'ゃ' => 'sha', 'ゅ' => 'shu', 'ょ' => 'sho'}, 'shi')
  ji = Hepburn.new({'ゃ' => 'ja', 'ゅ' => 'ju', 'ょ' => 'jo'}, 'ji')
  chi = Hepburn.new({'ゃ' => 'cha', 'ゅ' => 'chu', 'ょ' => 'cho'}, 'chi')
  ni = Hepburn.new({'ゃ' => 'nya', 'ゅ' => 'nyu', 'ょ' => 'nyo'}, 'ni')
  hi = Hepburn.new({'ゃ' => 'hya', 'ゅ' => 'hyu', 'ょ' => 'hyo'}, 'hi')
  bi = Hepburn.new({'ゃ' => 'bya', 'ゅ' => 'byu', 'ょ' => 'byo'}, 'bi')
  pi = Hepburn.new({'ゃ' => 'pya', 'ゅ' => 'pyu', 'ょ' => 'pyo'}, 'pi')
  mi = Hepburn.new({'ゃ' => 'mya', 'ゅ' => 'myu', 'ょ' => 'myo'}, 'mi')
  ri = Hepburn.new({'ゃ' => 'rya', 'ゅ' => 'ryu', 'ょ' => 'ryo'}, 'ri')
  kki = Hepburn.new({'ゃ' => 'kkya', 'ゅ' => 'kkyu', 'ょ' => 'kkyo'}, 'kki')
  ggi = Hepburn.new({'ゃ' => 'ggya', 'ゅ' => 'ggyu', 'ょ' => 'ggyo'}, 'ggi')
  sshi = Hepburn.new({'ゃ' => 'ssha', 'ゅ' => 'sshu', 'ょ' => 'ssho'}, 'sshi')
  jji = Hepburn.new({'ゃ' => 'jja', 'ゅ' => 'jju', 'ょ' => 'jjo'}, 'jji')
  tchi = Hepburn.new({'ゃ' => 'tcha', 'ゅ' => 'tchu', 'ょ' => 'tcho'}, 'tchi')
  hhi = Hepburn.new({'ゃ' => 'hhya', 'ゅ' => 'hhyu', 'ょ' => 'hhyo'}, 'hhi')
  bbi = Hepburn.new({'ゃ' => 'bbya', 'ゅ' => 'bbyu', 'ょ' => 'bbyo'}, 'bbi')
  ppi = Hepburn.new({'ゃ' => 'ppya', 'ゅ' => 'ppyu', 'ょ' => 'ppyo'}, 'ppi')
  tsu = Hepburn.new({'か' => 'kka', 'き' => kki, 'く' => 'kku', 'け' => 'kke', 'こ' => 'kko',
                     'が' => 'gga', 'ぎ' => ggi, 'ぐ' => 'ggu', 'げ' => 'gge', 'ご' => 'ggo',
                     'さ' => 'ssa', 'し' => sshi, 'す' => 'ssu', 'せ' => 'sse', 'そ' => 'sso',
                     'ざ' => 'zza', 'じ' => jji, 'ず' => 'zzu', 'ぜ' => 'zze', 'ぞ' => 'zzo',
                     'た' => 'tta', 'ち' => tchi, 'つ' => 'ttsu', 'て' => 'tte', 'と' => 'tto',
                     'だ' => 'dda', 'ぢ' => 'jji', 'づ' => 'zzu', 'で' => 'dde', 'ど' => 'ddo',
                     'は' => 'hha', 'ひ' => hhi, 'ふ' => 'ffu', 'へ' => 'hhe', 'ほ' => 'hho',
                     'ば' => 'bba', 'び' => bbi, 'ぶ' => 'bbu', 'べ' => 'bbe', 'ぼ' => 'bbo',
                     'ぱ' => 'ppa', 'ぴ' => ppi, 'ぷ' => 'ppu', 'ぺ' => 'ppe', 'ぽ' => 'ppo'}, 'っ')

  ik = Hepburn.new({'ェ' => 'ye'}, 'i')
  uk = Hepburn.new({'ィ' => 'wi'	, 'ェ' => 'we', 'ォ' => 'wo'}, 'u')
  vuk = Hepburn.new({'ァ' => 'va', 'ィ' => 'vi',	'ェ' => 've', 'ォ' => 'vo'}, 'vu')
  kik = Hepburn.new({'ャ' => 'kya', 'ュ' => 'kyu', 'ョ' => 'kyo'}, 'ki')
  gik = Hepburn.new({'ャ' => 'gya', 'ュ' => 'gyu', 'ョ' => 'gyo'}, 'gi')
  shik = Hepburn.new({'ャ' => 'sha', 'ュ' => 'shu', 'ョ' => 'sho',	'ェ' => 'she'}, 'shi')
  suk = Hepburn.new({'ィ' => 'si', 'ュ' => 'syu'}, 'su')
  jik = Hepburn.new({'ャ' => 'ja', 'ュ' => 'ju', 'ョ' => 'jo',	'ェ' => 'je'}, 'ji')
  zuk = Hepburn.new({'ィ' => 'zi', 'ュ' => 'zyu'}, 'zu')
  chik = Hepburn.new({'ャ' => 'cha', 'ュ' => 'chu', 'ョ' => 'cho',	'ェ' => 'che'}, 'chi')
  tsuk = Hepburn.new({'ァ' => 'tsa', 'ィ' => 'tsi',	'ェ' => 'tse', 'ォ' => 'tso'}, 'tsu')
  tek = Hepburn.new({'ィ' => 'ti', 'ュ' => 'tyu'}, 'te')
  tok = Hepburn.new({'ゥ' => 'tu'}, 'to')
  dek = Hepburn.new({'ィ' => 'di', 'ュ' => 'dyu'}, 'de')
  dok = Hepburn.new({'ゥ' => 'du'}, 'do')
  nik = Hepburn.new({'ャ' => 'nya', 'ュ' => 'nyu', 'ョ' => 'nyo'}, 'ni')
  hik = Hepburn.new({'ャ' => 'hya', 'ュ' => 'hyu', 'ョ' => 'hyo'}, 'hi')
  fuk = Hepburn.new({'ァ' => 'fa', 'ィ' => 'fi',	'ェ' => 'fe', 'ォ' => 'fo'}, 'fu')
  bik = Hepburn.new({'ャ' => 'bya', 'ュ' => 'byu', 'ョ' => 'byo'}, 'bi')
  pik = Hepburn.new({'ャ' => 'pya', 'ュ' => 'pyu', 'ョ' => 'pyo'}, 'pi')
  mik = Hepburn.new({'ャ' => 'mya', 'ュ' => 'myu', 'ョ' => 'myo'}, 'mi')
  rik = Hepburn.new({'ャ' => 'rya', 'ュ' => 'ryu', 'ョ' => 'ryo'}, 'ri')

  kkik = Hepburn.new({'ャ' => 'kkya', 'ュ' => 'kkyu', 'ョ' => 'kkyo'}, 'kki')
  ggik = Hepburn.new({'ャ' => 'ggya', 'ュ' => 'ggyu', 'ョ' => 'ggyo'}, 'ggi')
  sshik = Hepburn.new({'ャ' => 'ssha', 'ュ' => 'sshu', 'ョ' => 'ssho',	'ェ' => 'sshe'}, 'sshi')
  ssuk = Hepburn.new({'ィ' => 'ssi', 'ュ' => 'ssyu'}, 'ssu')
  jjik = Hepburn.new({'ャ' => 'jja', 'ュ' => 'jju', 'ョ' => 'jjo',	'ェ' => 'jje'}, 'jji')
  zzuk = Hepburn.new({'ィ' => 'zzi', 'ュ' => 'zzyu'}, 'zzu')
  tchik = Hepburn.new({'ャ' => 'tcha', 'ュ' => 'tchu', 'ョ' => 'tcho',	'ェ' => 'tche'}, 'tchi')
  ttsuk = Hepburn.new({'ァ' => 'ttsa', 'ィ' => 'ttsi',	'ェ' => 'ttse', 'ォ' => 'ttso'}, 'ttsu')
  ttek = Hepburn.new({'ィ' => 'tti', 'ュ' => 'ttyu'}, 'tte')
  ttok = Hepburn.new({'ゥ' => 'ttu'}, 'tto')
  ddek = Hepburn.new({'ィ' => 'ddi', 'ュ' => 'ddyu'}, 'dde')
  ddok = Hepburn.new({'ゥ' => 'ddu'}, 'ddo')
  hhik = Hepburn.new({'ャ' => 'hhya', 'ュ' => 'hhyu', 'ョ' => 'hhyo'}, 'hhi')
  ffuk = Hepburn.new({'ァ' => 'ffa', 'ィ' => 'ffi',	'ェ' => 'ffe', 'ォ' => 'ffo'}, 'ffu')
  bbik = Hepburn.new({'ャ' => 'bbya', 'ュ' => 'bbyu', 'ョ' => 'bbyo'}, 'bbi')
  ppik = Hepburn.new({'ャ' => 'ppya', 'ュ' => 'ppyu', 'ョ' => 'ppyo'}, 'ppi')

  tsuk2 = Hepburn.new({'カ' => 'kka', 'キ' => kkik, 'ク' => 'kku', 'ケ' => 'kke', 'コ' => 'kko',
                       'ガ' => 'gga', 'ギ' => ggik, 'グ' => 'ggu' , 'ゲ' => 'gge', 'ゴ' => 'ggo',
                       'サ' => 'ssa', 'シ' => sshik, 'ス' => ssuk, 'セ' => 'sse', 'ソ' => 'sso',
                       'ザ' => 'zza', 'ジ' => jjik, 'ズ' => zzuk, 'ゼ' => 'zze', 'ゾ' => 'zzo',
                       'タ' => 'tta', 'チ' => tchik, 'ツ' => ttsuk, 'テ' => ttek, 'ト' => ttok,
                       'ダ' => 'dda', 'ヂ' => 'jji', 'ヅ' => 'zzu', 'デ' => ddek, 'ド' => ddok,
                       'ハ' => 'hha', 'ヒ' => hhik, 'フ' => ffuk, 'ヘ' => 'hhe', 'ホ' => 'hho',
                       'バ' => 'bba', 'ビ' => bbik, 'ブ' => 'bbu', 'ベ' => 'bbe', 'ボ' => 'bbo',
                       'パ' => 'ppa', 'ピ' => ppik, 'プ' => 'ppu', 'ペ' => 'ppe', 'ポ' => 'ppo'},'ッ')

  @romaji = Hepburn.new({'あ' => 'a', 'い' => 'i', 'う' => 'u', 'え' => 'e', 'お' => 'o', '、' => ',', '。' => '.',
                          'か' => 'ka', 'き' => ki, 'く' => 'ku', 'け' => 'ke', 'こ' => 'ko',
                          'が' => 'ga', 'ぎ' => gi, 'ぐ' => 'gu', 'げ' => 'ge', 'ご' => 'go',
                          'さ' => 'sa', 'し' => shi, 'す' => 'su', 'せ' => 'se', 'そ' => 'so',
                          'ざ' => 'za', 'じ' => ji, 'ず' => 'zu', 'ぜ' => 'ze', 'ぞ' => 'zo',
                          'た' => 'ta', 'ち' => chi, 'つ' => 'tsu', 'て' => 'te', 'と' => 'to',
                          'だ' => 'da', 'ぢ' => 'ji', 'づ' => 'zu', 'で' => 'de', 'ど' => 'do',
                          'な' => 'na', 'に' => ni, 'ぬ' => 'nu', 'ね' => 'ne', 'の' => 'no', 'ん' => 'n',
                          'は' => 'ha', 'ひ' => hi, 'ふ' => 'fu', 'へ' => 'he', 'ほ' => 'ho',
                          'ば' => 'ba', 'び' => bi, 'ぶ' => 'bu', 'べ' => 'be', 'ぼ' => 'bo',
                          'ぱ' => 'pa', 'ぴ' => pi, 'ぷ' => 'pu', 'ぺ' => 'pe', 'ぽ' => 'po',
                          'ま' => 'ma', 'み' => mi, 'む' => 'mu', 'め' => 'me', 'も' => 'mo',
                          'ら' => 'ra', 'り' => ri, 'る' => 'ru', 'れ' => 're', 'ろ' => 'ro',
                          'や' => 'ya', 'ゆ' => 'yu', 'よ' => 'yo', 'わ' => 'wa', 'を' => 'wo', 'っ' => tsu,
                          'ア' => 'a', 'イ' => ik, 'ウ' => uk, 'エ' => 'e', 'オ' => 'o', 'ヴ' => vuk,
                          'カ' => 'ka', 'キ' => kik, 'ク' => 'ku', 'ケ' => 'ke', 'コ' => 'ko',
                          'ガ' => 'ga', 'ギ' => gik, 'グ' => 'gu' , 'ゲ' => 'ge', 'ゴ' => 'go',
                          'サ' => 'sa', 'シ' => shik, 'ス' => suk, 'セ' => 'se', 'ソ' => 'so',
                          'ザ' => 'za', 'ジ' => jik, 'ズ' => zuk, 'ゼ' => 'ze', 'ゾ' => 'zo',
                          'タ' => 'ta', 'チ' => chik, 'ツ' => tsuk, 'テ' => tek, 'ト' => tok,
                          'ダ' => 'da', 'ヂ' => 'ji', 'ヅ' => 'zu', 'デ' => dek, 'ド' => dok,
                          'ナ' => 'na', 'ニ' => nik, 'ヌ' => 'nu', 'ネ' => 'ne', 'ノ' => 'no', 'ン' => 'n',
                          'ハ' => 'ha', 'ヒ' => hik, 'フ' => fuk, 'ヘ' => 'he', 'ホ' => 'ho',
                          'バ' => 'ba', 'ビ' => bik, 'ブ' => 'bu', 'ベ' => 'be', 'ボ' => 'bo',
                          'パ' => 'pa', 'ピ' => pik, 'プ' => 'pu', 'ペ' => 'pe', 'ポ' => 'po',
                          'マ' => 'ma', 'ミ' => mik, 'ム' => 'mu', 'メ' => 'me', 'モ' => 'mo',
                          'ラ' => 'ra', 'リ' => rik, 'ル' => 'ru', 'レ' => 're', 'ロ' => 'ro',
                          'ヤ' => 'ya', 'ユ' => 'yu', 'ヨ' => 'yo', 'ワ' => 'wa', 'ヲ' => 'wo', 'ッ' => tsuk2
                         })
  blub = [ki, gi, shi, ji, chi, ni, hi, bi, pi, mi, ri, tsu, kki, ggi, sshi, jji, tchi, hhi, bbi, ppi, @romaji,
          ik, uk, vuk, kik, gik, shik, suk, jik, zuk, chik, tsuk, tek, tok, dek, dok, nik, hik, fuk, bik, pik, mik, rik,
          kik, ggik, sshik, ssuk, jjik, zzuk, tchik, ttsuk, ttek, ttok, ddek, ddok, hhik, ffuk, bbik, ppik, tsuk2]

  blub.each do |hepburn|
    hepburn.next_char = @romaji
  end


  y = Hepburn.new({'a' => 'ヤ', 'u' => 'ユ', 'o' => 'ヨ', 'e' => 'イェ'}, 'y')

  hhy = Hepburn.new({'a' => 'ッヒャ', 'u' => 'ッヒュ', 'o' => 'ッヒョ'}, 'hh', y)
  hh = Hepburn.new({'a' => 'ッハ', 'i' => 'ッヒ', 'u' => 'ッフ', 'e' => 'ッヘ', 'o' => 'ッホ', 'y' => hhy}, 'hh')
  hy = Hepburn.new({'a' => 'ヒャ', 'u' => 'ヒュ', 'o' => 'ヒョ'}, 'h', y)
  h = Hepburn.new({'a' => 'ハ', 'i' => 'ヒ', 'u' => 'フ', 'e' => 'ヘ', 'o' => 'ホ', 'y' => hy, 'h' => hh}, 'h')
  ffy = Hepburn.new({'u' => 'ッフュ', 'o' => 'ッフョ'}, 'ff', y)
  ff = Hepburn.new({'a' => 'ッファ', 'i' => 'ッフィ', 'u' => 'ッフ', 'e' => 'ッフェ', 'o' => 'ッフォ', 'y' => ffy}, 'ff')
  fy = Hepburn.new({'u' => 'ッフュ', 'o' => 'ッフョ'}, 'f', y)
  f = Hepburn.new({'a' => 'ファ', 'i' => 'フィ', 'u' => 'フ', 'e' => 'フェ', 'o' => 'フォ', 'y' => fy ,'f' => ff}, 'f')

  bby = Hepburn.new({'a' => 'ッビャ', 'u'  => 'ッビュ', 'o'  => 'ッビョ'}, 'bb', y)
  bb = Hepburn.new({'a' => 'ッバ' , 'i' => 'ッビ', 'u' => 'ッブ', 'e'  => 'ッベ', 'o' => 'ッボ', 'y' => bby}, 'bb')
  by = Hepburn.new({'a' => 'ビャ', 'u'  => 'ビュ', 'o'  => 'ビョ'}, 'b', y)
  b = Hepburn.new({'a' => 'バ' , 'i' => 'ビ', 'u' => 'ブ', 'e'  => 'ベ', 'o' => 'ボ', 'y' => by, 'b' => bb}, 'b')

  ppy = Hepburn.new({'a' => 'ッピャ', 'u' => 'ッピュ', 'o' => 'ッピョ'}, 'pp', y)
  pp = Hepburn.new({'a' => 'ッパ', 'i' => 'ッピ', 'u' => 'ップ', 'e' => 'ッペ', 'o' => 'ッポ', 'y' => ppy}, 'pp')
  py = Hepburn.new({'a' => 'ピャ', 'u' => 'ピュ', 'o' => 'ピョ'}, 'p', y)
  p = Hepburn.new({'a' => 'パ', 'i' => 'ピ', 'u' => 'プ', 'e' => 'ペ', 'o' => 'ポ', 'y' => py, 'p' => pp}, 'p')

  kky = Hepburn.new({'a' => 'ッキョ', 'u' => 'ッキュ', 'o' => 'ッキョ'}, 'kk', y)
  kk = Hepburn.new({'a' => 'ッカ', 'i' => 'ッキ', 'u'  => 'ック', 'e' => 'ッケ', 'o' => 'ッコ', 'y' =>  kky}, 'kk')
  ky = Hepburn.new({'a' => 'キョ', 'u' => 'キュ', 'o' => 'キョ'}, 'k', y)
  k = Hepburn.new({'a' => 'カ', 'i' => 'キ', 'u'  => 'ク', 'e' => 'ケ', 'o' => 'コ', 'y' =>  ky, 'k' => kk}, 'k')

  ggy = Hepburn.new({'a' => 'ッギャ', 'u' => 'ッギュ', 'o' => 'ッギョ'}, 'gg', y)
  gg = Hepburn.new({'a' => 'ッガ', 'i' => 'ッギ', 'u' => 'ッグ', 'e' => 'ッゲ', 'o' => 'ッゴ', 'y' => ggy}, 'gg')
  gy = Hepburn.new({'a' => 'ギャ', 'u' => 'ギュ', 'o' => 'ギョ'}, 'g', y)
  g = Hepburn.new({'a' => 'ガ', 'i' => 'ギ', 'u' => 'グ', 'e' => 'ゲ', 'o' => 'ゴ', 'y' => gy, 'g' => gg}, 'g')


  ssh = Hepburn.new({'a' => 'ッシャ', 'i' => 'ッシ', 'u' => 'ッシュ', 'e' => 'ッシェ', 'o' => 'ッショ'}, 'ss', h)
  ssy = Hepburn.new({'u' => 'ッシェ'}, 'ss', y)
  ss = Hepburn.new({'a' => 'ッサ', 'i' => 'ッシ', 'u' => 'ッス', 'e' => 'ッセ', 'o' => 'ッソ', 'h' => ssh, 'y' => ssy}, 'ss')
  sh = Hepburn.new({'a' => 'シャ', 'i' => 'シ', 'u' => 'シュ', 'e' => 'シェ', 'o' => 'ショ'}, 's', h)
  sy = Hepburn.new({'u' => 'スュ'}, 's', y)
  s = Hepburn.new({'a' => 'サ', 'i' => 'スィ', 'u' => 'ス', 'e' => 'セ', 'o' => 'ソ', 'h' => sh, 'y' => sy, 's' => ss}, 's')

  zzy = Hepburn.new({'u' => 'ッズュ'}, 'zz', y)
  zz = Hepburn.new({'a' => 'ッザ', 'i' => 'ッズィ', 'u' => 'ッズ', 'e' => 'ッゼ', 'o' => 'ッゾ', 'y' => zzy}, 'zz')
  zy = Hepburn.new({'u' => 'ズュ'}, 'z', y)
  z = Hepburn.new({'a' => 'ザ', 'i' => 'ズィ', 'u' => 'ズ', 'e' => 'ゼ', 'o' => 'ゾ', 'y' => zy, 'z' => zz}, 'z')
  jj = Hepburn.new({'a' => 'ッジャ', 'i' => 'ッジ', 'u' => 'ッジュ', 'e' => 'ッジェ', 'o' => 'ッジョ'}, 'jj')
  j = Hepburn.new({'a' => 'ジャ', 'i' => 'ジ', 'u' => 'ジュ', 'e' => 'ジェ', 'o' => 'ジョ', 'j' => jj}, 'j')

  tts = Hepburn.new({'a' => 'ッツァ', 'i' => 'ッツィ', 'u' => 'ッツ', 'e' => 'ッツェ', 'o' => 'ッツォ'}, 'tt', s)
  tty = Hepburn.new({'u' => 'ッテュ'}, 'tt', y)
  tt = Hepburn.new({'a' => 'ッタ', 'i' => 'ッティ', 'u' => 'ットゥ', 'e' => 'ッテ', 'o' => 'ット', 's' => tts, 'y' => tty}, 'tt')
  tch = Hepburn.new({'a' => 'ッチャ', 'i' => 'ッチ', 'u' => 'ッチュ', 'e' => 'ッチェ', 'o' => 'ッチョ'}, 'tc', h)
  tc = Hepburn.new({'h' => tch}, 'tc')
  ts = Hepburn.new({'a' => 'ツァ', 'i' => 'ツィ', 'u' => 'ツ', 'e' => 'ツェ', 'o' => 'ツォ'}, 't', s)
  ty = Hepburn.new({'u' => 'テュ'}, 't', y)
  t = Hepburn.new({'a' => 'タ', 'i' => 'ティ', 'u' => 'トゥ', 'e' => 'テ', 'o' => 'ト', 's' => ts, 't' => tt, 'c' => tc, 'y' => ty}, 't')
  ch = Hepburn.new({'a' => 'チャ', 'i' => 'チ', 'u' => 'チュ', 'e' => 'チェ', 'o' => 'チョ'}, 'c', h)
  c = Hepburn.new({'h' => ch}, 'c')

  ddy = Hepburn.new({'u' => 'ッデュ'}, 'dd', y)
  dd = Hepburn.new({'a' => 'ッダ', 'i' => 'ッディ', 'u' => 'ッドゥ', 'e' => 'ッデ', 'o' => 'ッド', 'y' => ddy}, 'dd')
  dy = Hepburn.new({'u' => 'デュ'}, 'd', y)
  d = Hepburn.new({'a' => 'ダ', 'i' => 'ディ', 'u' => 'ドゥ', 'e' => 'デ', 'o' => 'ド', 'y' => dy, 'd' => dd}, 'd')

  ny = Hepburn.new({'a' => 'ニャ', 'u' => 'ニュ' , 'o' => 'ニョ'}, 'ン', y)
  n = Hepburn.new({'a' => 'ナ', 'i' => 'ニ', 'u' => 'ヌ', 'e'=> 'ネ', 'o' => 'ノ', 'y' => ny}, 'ン')

  my = Hepburn.new({'a' => 'ミャ', 'u' => 'ミュ', 'o' => 'ミョ'}, 'm', y)
  m = Hepburn.new({'a' => 'マ', 'i' => 'ミ', 'u' => 'ム', 'e' => 'メ', 'o' => 'モ', 'y' => my}, 'm')

  ry = Hepburn.new({'a' => 'リャ', 'u' => 'リュ', 'o' => 'リョ'}, 'r', y)
  r = Hepburn.new({'a' => 'ラ', 'i' => 'リ', 'u' => 'ル', 'e' => 'レ', 'o' => 'ロ', 'y' => ry}, 'r')

  w = Hepburn.new({'a' => 'ワ', 'i' => 'ウィ', 'e' => 'ウェ', 'o' => 'ウォ'}, 'w')
  v = Hepburn.new({'a' => 'ヴァ', 'i' => 'ヴィ', 'u' => 'ヴ', 'e' => 'ヴェ', 'o' => 'ヴォ'})

  @katakana = Hepburn.new({'a' => 'ア', 'i' => 'イ', 'u' => 'ウ', 'e' => 'エ', 'o' => 'オ', ',' => '、', '.' => '。',
                            'k' => k, 'g' => g, 's' => s, 'z' => z, 'j' => j, 't' => t, 'd' => d, 'c' => c, 'n' => n,
                            'h' => h, 'f' => f, 'b' => b, 'p' => p, 'm' => m, 'r' => r, 'y' => y, 'w' => w, 'v' => v})
  blub = [y, hh, h, ff, f, bb, b, pp, p, kk, k, gg, g, ss, s, zz, z, jj, j, tt, tc, t, c, dd, d,  n, m, r , w, v, @katakana]
  blub.each do |hepburn|
    hepburn.next_char = @katakana
  end
end

class String
  def to_hiragana
    Hepburn.to_hiragana(self)
  end

  def to_romaji
    Hepburn.to_romaji(self)
  end

  def to_katakana
    Hepburn.to_katakana(self)
  end
end

#puts Hepburn.hira_yaml
#puts Hepburn.romaji_yaml
#puts Hepburn.kata_yaml