# coding: UTF-8

Plugin.create(:mikutter_osc) {
  require File.join(CHIConfig::PLUGIN_PATH, "change_account", "interactive")

  $users = Set.new

  PLACE_TABLE = {
    :SC => "１号館４Ｆ サイエンスホール",
    :AV => "１号館４Ｆ AV会議室",
    :A => "１号館４Ｆ 会議室Ａ",
    :B => "１号館４Ｆ 会議室Ｂ",
    :C => "１号館４Ｆ 会議室Ｃ",
    :D => "１号館４Ｆ 会議室Ｄ",
    :E => "１号館４Ｆ 会議室Ｅ",
    :OS => "アトリウム１Ｆ オープンスペース",
    :EV => "１号館４Ｆ エレベーター前",
  }

  TIME_TABLE = {
    :_1_10 => [Time.parse("15/08/07 10:00:00"), Time.parse("15/08/07 10:45:00")],
    :_1_11 => [Time.parse("15/08/07 11:00:00"), Time.parse("15/08/07 11:45:00")],
    :_1_12 => [Time.parse("15/08/07 12:00:00"), Time.parse("15/08/07 12:45:00")],
    :_1_13 => [Time.parse("15/08/07 13:00:00"), Time.parse("15/08/07 13:45:00")],
    :_1_14 => [Time.parse("15/08/07 14:00:00"), Time.parse("15/08/07 14:45:00")],
    :_1_15 => [Time.parse("15/08/07 15:15:00"), Time.parse("15/08/07 16:00:00")],
    :_1_16 => [Time.parse("15/08/07 16:15:00"), Time.parse("15/08/07 17:00:00")],

    :_2_10 => [Time.parse("15/08/08 10:00:00"), Time.parse("15/08/08 10:45:00")],
    :_2_11 => [Time.parse("15/08/08 11:00:00"), Time.parse("15/08/08 11:45:00")],
    :_2_12 => [Time.parse("15/08/08 12:00:00"), Time.parse("15/08/08 12:45:00")],
    :_2_13 => [Time.parse("15/08/08 13:00:00"), Time.parse("15/08/08 13:45:00")],
    :_2_14 => [Time.parse("15/08/08 14:00:00"), Time.parse("15/08/08 14:45:00")],
    :_2_15 => [Time.parse("15/08/08 15:15:00"), Time.parse("15/08/08 16:00:00")],
    :_2_16 => [Time.parse("15/08/08 16:10:00"), Time.parse("15/08/08 17:50:00")],
  }

  Seminor = Struct.new(:time, :place, :subject)

  SEMINORS = [
    Seminor.new(:_1_10, :SC, "HTML5開発最前線"),

    Seminor.new(:_1_11, :SC, "業界をリードするオープンソース仮想化プラットフォーム、XenServer最新情報"),
    Seminor.new(:_1_11, :AV, "OSSライセンスと著作権法の概要"),
    Seminor.new(:_1_11, :A, "PostgreSQLトラブルシュート"),
    Seminor.new(:_1_11, :B, "AMDが推進するHSA(OpenCL)やARMやAPU製品、GPU製品の最新の開発状況をお届け！"),

    Seminor.new(:_1_12, :A, "ライトニングトーク（by OSCスポンサー）"),
    Seminor.new(:_1_12, :B, "VPS もデスクトップも YaST を使って Linux をらくらく設定―ファイルサーバー構築・管理編
"),

    Seminor.new(:_1_13, :SC, "これから始める人のための自動化入門～Ubuntu Jujuを使って～"),
    Seminor.new(:_1_13, :AV, "小型コンピュータ Raspberry Pi へのいざない"),
    Seminor.new(:_1_13, :A, "スマホアプリのオープンソース「Piece（ピース）」の活用方法と導入事例"),
    Seminor.new(:_1_13, :B, "DDNのクラウドプラットフォームビジネスへの取り組み　～導入事例、性能検証結果を交えて～"),
    Seminor.new(:_1_13, :EV, "展示ブースツアー1回目\n\n予約：http://www.ospn.jp/osc2015-kyoto/modules/eguide/event.php?eid=70"),

    Seminor.new(:_1_14, :SC, "豪華2本立て『オープンソース入門』『OSSプランニングエンジン OptaPlannerを使ってみよう！』"),
    Seminor.new(:_1_14, :AV, "3年ぶりの大規模メジャーバージョンアップ「Hinemos ver.5.0」～監視もジョブもDevもOpsもHinemosで～"),
    Seminor.new(:_1_14, :A, "Postgresへのスマートなデータ移行とアプリケーション開発"),
    Seminor.new(:_1_14, :B, "Ejectコマンド工作、その魅力に迫る。"),
    Seminor.new(:_1_14, :EV, "展示ブースツアー2回目（最終）\n\n予約：http://www.ospn.jp/osc2015-kyoto/modules/eguide/event.php?eid=70"),

    Seminor.new(:_1_15, :SC, "Pandora FMS でサーバ 1台から大規模サイトまでの幅広い監視を実現 ～統合監視ツール Pandora FMS の実力～"),
    Seminor.new(:_1_15, :AV, "自治体の港湾業務システムをSymfony2でゼロから作ってみた。"),
    Seminor.new(:_1_15, :A, "CMS「concrete5」最新事情"),
    Seminor.new(:_1_15, :B, "NetBSDのご紹介"),

    Seminor.new(:_1_16, :SC, "無償エディションも登場！インフラエンジニアなら知っておきたい、Nutanixによる仮想化環境とストレージのあたらしい形"),
    Seminor.new(:_1_16, :AV, "AllJoynフレームワークを使ったインターネット・オブ・エブリシング（IoE）の開発"),
    Seminor.new(:_1_16, :A, "知って『得』する！Hinemos活用術"),
    Seminor.new(:_1_16, :B, "MySQL開発最新動向"),

    Seminor.new(:_2_10, :SC, "OpenStackの概要と最新動向"),
    Seminor.new(:_2_10, :AV, "オープンソース！Open Flow 1.3 対応！日本発のネットワークスイッチOS「Lagopus Switch」"),
    Seminor.new(:_2_10, :A, "DNS初めの一歩とダイナミックDNSの今＆GVCによるオープンハード・オープンソースでの遠隔操作の紹介"),
    Seminor.new(:_2_10, :B, "WP-APIを使ったNo PHPなWordPressサイトを考える"),
    Seminor.new(:_2_10, :C, "Wikipedia の情報をもっと有効活用する Wikipedia Word Analyzer を開発するに当たって"),
    Seminor.new(:_2_10, :D, "中古コンデジを活用して勉強会の面白さ・楽しさを伝える"),
    Seminor.new(:_2_10, :OS, "かわいくておしゃれな電子ブロック littleBits で遊びながらコンピュータの原理を学ぼう！"),

    Seminor.new(:_2_11, :SC, "FirefoxとWebの未来 - Mozillaはこれから何にフォーカスしていくのか"),
    Seminor.new(:_2_11, :AV, "新入社員のための大規模ゲーム開発入門 サーバサイド編"),
    Seminor.new(:_2_11, :A, "「コーポレートサイトにちょうどいい」baserCMSの機能とコミュニティのこれから"),
    Seminor.new(:_2_11, :B, "地理空間オープンデータの可視化を、オープンソースGISで簡単に！"),
    Seminor.new(:_2_11, :C, "Raspberry Pi＋Pifaceでホームセキュリティとホームエレクトロニクスを実現させます。"),
    Seminor.new(:_2_11, :D, "LibreOfficeの最新動向/LibreOfficeの使いどころ"),
    Seminor.new(:_2_11, :E, "Debian Updates (Jessie, Stretch, Buster)"),
    Seminor.new(:_2_11, :OS, "セキュリティ競技CTFって何？～CTFを通じて楽しくセキュリティとふれ合おう～"),
    Seminor.new(:_2_11, :EV, "展示ブースツアー 1回目\n\n予約：http://www.ospn.jp/osc2015-kyoto/modules/eguide/event.php?eid=70"),

    Seminor.new(:_2_12, :SC, "インフラエンジニア、アプリ開発者集まれ！今注目のクラウド 「Bluemix」、「SoftLayer」をはじめよう！"),
    Seminor.new(:_2_12, :AV, "Samba4を「ふつうに」使おう！Samba4によるファイルサーバ構築テクニック"),
    Seminor.new(:_2_12, :A, "東海道らぐ真夏のLinuxライトニングトーク大会＠ておくれない"),
    Seminor.new(:_2_12, :B, "Drupalハンズオン!～初めての人も歓迎! ローカルでDrupalを動かしてみよう"),
    Seminor.new(:_2_12, :C, "とことん紹介！OpenStreetMapとその活用事例"),
    Seminor.new(:_2_12, :D, "xrdpのご紹介 ～シンクライアントとの組み合わせでVDI～"),
    Seminor.new(:_2_12, :OS, "KMC(京大マイコンクラブ)学習発表会"),
    Seminor.new(:_2_12, :EV, "展示ブースツアー2回目\n\n予約：http://www.ospn.jp/osc2015-kyoto/modules/eguide/event.php?eid=70"),

    Seminor.new(:_2_13, :SC, "今こそ語るエンジニアの幸せな未来～OSC京都編～"),
    Seminor.new(:_2_13, :AV, "コンテナ(Docker)時代のインフラ技術・運用管理に迫る！"),
    Seminor.new(:_2_13, :A, "HTML5レベル1ポイント解説セミナー"),
    Seminor.new(:_2_13, :B, "『会員サイト』を簡単に作っちゃおう。国産CMSネットコモンズのススメ。"),
    Seminor.new(:_2_13, :C, "手軽に買える機器をハックして、 メーカが提供している以上の機能、性能を引き出そう！！"),
    Seminor.new(:_2_13, :D, "Contao Open Source CMSの最新動向 ～ バージョン3.5 LTSと4.0"),
    Seminor.new(:_2_13, :E, "TIBCO Jaspersoft概要 / JasperReportsでエクセルシートを作った事例"),
    Seminor.new(:_2_13, :OS, "ロケットや自動車にも搭載！高品質な組込み向けオープンソースを開発するTOPPERSプロジェクトのご紹介"),
    Seminor.new(:_2_13, :EV, "展示ブースツアー3回目（最終）\n\n予約：http://www.ospn.jp/osc2015-kyoto/modules/eguide/event.php?eid=70"),

    Seminor.new(:_2_14, :SC, "異なる領域を組み合わせたものづくりを文化として根付かせるには～ArduinoやPICマイコンでIoTやアートを楽しもう～"),
    Seminor.new(:_2_14, :AV, "クラウド時代を生きぬくためのITエンジニアとシステムインテグレータの OSS活用！"),
    Seminor.new(:_2_14, :A, "次世代ECプラットフォーム「EC-CUBE 3」に迫る！「3」で何が変わったのか！？"),
    Seminor.new(:_2_14, :B, "Ubuntuがこの先、生きのこるには"),
    Seminor.new(:_2_14, :C, "Android Nexus7でLinuxを色々と遊んでみよう"),
    Seminor.new(:_2_14, :D, "Vine Linux の最新動向―最新安定版 Vine Linux 7 \"Ausone\" の紹介―"),
    Seminor.new(:_2_14, :E, "----------"),
    Seminor.new(:_2_14, :OS, "「オープンデータで田舎をイノベーション」他"),

    Seminor.new(:_2_15, :SC, "分散処理基盤Apache Hadoop入門とHadoopエコシステムの最新技術動向"),
    Seminor.new(:_2_15, :AV, "新しくなったクラウドプラットフォーム「ConoHa」を使ってみよう！"),
    Seminor.new(:_2_15, :A, "jus研究会京都大会「IT系女子大生の育て方」"),
    Seminor.new(:_2_15, :B, "現役IT担当者が語る！中小企業のIT化を行なう上で重要な事とは！"),
    Seminor.new(:_2_15, :C, "オープンソースを活用したIoTの活用方法について"),
    Seminor.new(:_2_15, :D, "LEGO Mindstorms の遊び方"),

    Seminor.new(:_2_16, :SC, "ライトニングトーク＆大抽選会＆閉会式"),
  ]

  # ループする人
  class OSCLooper
    attr_reader :stop

    def initialize
      @stop = false
    end

    def start(timer_set, &proc)
      proc.call

      interval = timer_set.call

      if !interval
        @stop = true
        return
      end

      Reserver.new(interval) { start(timer_set, &proc) }
    end
  end

  # 今以降直近のセミナーの時刻を得る
  def get_next_seminor_time(time)
    result = TIME_TABLE.find { |key, semi_time|
      (semi_time[1] > time) && ( semi_time[0] > time )
    }

    if result
      result[0]
    else
      nil
    end
  end

  # ヘッダメッセージを生成する
  def make_header_msg(next_seminor_time)
    msg = []
    msg << "ぴんぽんぱんぽーん♪"
    msg << "次のイベントのお知らせです。"
    msg << ""
    msg << "●●●#{TIME_TABLE[next_seminor_time][0].strftime("%e日%H:%Mより")}●●●"

    Message.new(:message => msg.join("\n"), :system => true)
  end

  # メッセージを生成する
  def make_msgs(seminors)
    seminor_msgs = seminors.map { |sem|
      msg = [
        "【#{PLACE_TABLE[sem.place]}】", 
        "",
        "#{sem.subject}"
      ]

      Message.new(:message => msg.join("\n"), :system => true, :confirm => { "行く！" => :join }, :confirm_callback => lambda { |button|
        post_message = [
          "次は「#{sem.subject}」に行きます。",
          "",
          "#ＯＳＣ関西に来ています"
        ]

        Service.primary.update(:message => post_message.join("\n"))
      })
    }

    msg = [
      "それとも、ブースを見に行く？"
    ]

    seminor_msgs << Message.new(:message => msg.join("\n"), :system => true, :confirm => { "そうしよう" => :join }, :confirm_callback => lambda { |button|
      post_message = [
        "次はブースを見学します。",
        "",
        "#ＯＳＣ関西に来ています"
      ]

      Service.primary.update(:message => post_message.join("\n"))
    })

    seminor_msgs
  end

  # イベント案内を表示
  def show_seminors(next_seminor_time, seminors)
    timeline(:home_timeline) << make_header_msg(next_seminor_time)

    make_msgs(seminors).each_with_index { |seminor, i|
      Reserver.new(i * 3 + 3) {
        Delayer.new {
          seminor[:modified] = Time.now
          timeline(:home_timeline) << seminor
        }
      }
    }
  end
 
  # 起動時処理
  on_boot { |service|
    next_seminor_time = get_next_seminor_time(Time.now)

    seminors = SEMINORS.select { |sem|
      sem.time == next_seminor_time
    }

    if seminors.length != 0
      timeline(:home_timeline) << make_header_msg(next_seminor_time)
      timeline(:home_timeline) << Messages.new(Array(make_msgs(seminors)[0]))

      Reserver.new(3) {
        Delayer.new {
          msg = [
            "こんな感じで開始15分前に次のイベントをお知らせするね。",
            "",
            "お知らせはウインドウ下部のOSCボタンでも見られるよ。",
            "",
            "情報は8/3時点のものだから、会場の最新情報も必ずチェックしてね。",
            "",
          ]

          timeline(:home_timeline) << Message.new(:message => msg.join("\n"), :system => true)
        }
      }

      Reserver.new(6) {
        Delayer.new {
          msg = [
            "「行く！」ボタンを押すと、",
            "",
            "#ＯＳＣ関西に来ています",
            "",
            "ハッシュタグ付きでイベント名をツイートするよ。"
          ]

          timeline(:home_timeline) << Message.new(:message => msg.join("\n"), :system => true)
        }
      }

      Reserver.new(9) {
        Delayer.new {
          msg = [
            "さらに！",
            "",
            "#ＯＳＣ関西に来ています",
            "ハッシュタグ付きの人を見つけたら",
            "",
            "↓こんな感じでお知らせするね。",
            "",
          ]

          timeline(:home_timeline) << Message.new(:message => msg.join("\n"), :system => true, :osc => true)
        }
      }

      Reserver.new(12) {
        Delayer.new {
          msg = [
            "ではでは！",
            "",
            "OSC関西@京都2015",
            "",
            "楽しみましょー♪",
          ]

          timeline(:home_timeline) << Message.new(:message => msg.join("\n"), :system => true)
        }
      }

      # ループ開始
      @first_flag = false

      OSCLooper.new.start(-> {1 * 60 + 1}) {
        # ておくれ探し
        Service.primary.search(:q => "\"#ＯＳＣ関西に来ています\"", :count => 100).next { |res|
          res.each { |message|
            $users << message[:user][:screen_name]
          }
        }.trap { |e|
          puts e
          puts e.backtrace
        }

        # 初回は説明ツイートと被るので動かさない
        if !@first_flag
          @first_flag = true
          next
        end

        # 15分前チェック
        next_seminor_time = get_next_seminor_time(Time.now)

        if ((TIME_TABLE[next_seminor_time][0] - Time.now) <= (15 * 60)) && (@last_notified != next_seminor_time)
          seminors = SEMINORS.select { |sem|
            sem.time == next_seminor_time
          }

          if seminors.length != 0
            show_seminors(next_seminor_time, seminors)
            @last_notified = next_seminor_time
          end
        end
      }
    end
  }

  # コマンド
  command(:notify_seminor, name: "次のイベントは？", condition: lambda { |opt| true }, visible: true, icon: "http://www.ospn.jp/favicon.ico", role: :window) { |opt|
    next_seminor_time = get_next_seminor_time(Time.now)

    seminors = SEMINORS.select { |sem|
      sem.time == next_seminor_time
    }

    if seminors.length != 0
      show_seminors(next_seminor_time, seminors)
    end
  }

  class OSCSubPartsMemo < ::Gdk::SubParts
    regist

    def initialize(*args)
      super(*args)
    end

    def get_toshi_a_layout(context = dummy_context)
      memo = [
        "↑ふぁぼれ！",
        "ておくれ神降臨！",
        "ふぁぼ不足！",
        "※作者です",
        "※ておくれです",
      ].sample

      (attr_list, text) = Pango.parse_markup(memo)
      layout = context.create_pango_layout
      layout.width = width * Pango::SCALE
      layout.attributes = attr_list
      layout.wrap = Pango::WRAP_CHAR

      UserConfig[:mumble_reply_font] =~ / ([0-9]+)$/
      big_font = UserConfig[:mumble_reply_font].gsub(/ ([0-9]+)$/, " #{$1.to_i * 1.5}")

      layout.font_description = Pango::FontDescription.new(big_font)
      layout.text = memo

      layout
    end

    def get_memo_layout(context = dummy_context)
      memo = "OSC関西2015参加中"

      (attr_list, text) = Pango.parse_markup(memo)
      layout = context.create_pango_layout
      layout.width = width * Pango::SCALE
      layout.attributes = attr_list
      layout.wrap = Pango::WRAP_CHAR
      layout.font_description = Pango::FontDescription.new(UserConfig[:mumble_reply_font])
      layout.text = memo

      layout
    end

    def height
      if helper.message[:user][:screen_name] == "toshi_a"
        get_toshi_a_layout.pixel_size[1]
      elsif $users.include?(helper.message[:user][:screen_name]) || helper.message[:osc]
        get_memo_layout.pixel_size[1]
      else
        0
      end
    end

    def render(context)
      if ($users.include?(helper.message[:user][:screen_name]) || helper.message[:osc] || helper.message[:user][:screen_name] == "toshi_a") && helper.visible? && helper.message 
        context.save{
          icon_size = 16

          context.translate(helper.icon_margin, 0)
          pixbuf = Gtk::WebIcon.new("http://www.ospn.jp/favicon.ico", icon_size, icon_size).pixbuf
          context.set_source_pixbuf(pixbuf)
          context.paint

          context.translate(icon_size + helper.icon_margin * 2, 0)

          if helper.message[:user][:screen_name] == "toshi_a"
            context.set_source_rgb([65535, 0, 0].map{ |c| c.to_f / 65536 })
            context.show_pango_layout(get_toshi_a_layout(context))
          else
            context.set_source_rgb([0, 0, 65535].map{ |c| c.to_f / 65536 })
            context.show_pango_layout(get_memo_layout(context))
          end
        }
      end
    end
  end
}
