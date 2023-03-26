module ApplicationHelper
    def default_meta_tags
    {
      site: 'Pluspo',
      title: '都内スポーツ施設の横断検索サービス',
      reverse: true,
      charset: 'utf-8',
      description: 'Pluspoを使えば「スポーツ・日時・場所」の好きな組み合わせで自由にスポーツ施設を検索できます。',
      keywords: 'スポーツ,スポーツ施設,東京',
      canonical: request.original_url,
      separator: '|',
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: 'website',
        url: request.original_url,
        image: image_url('sample.jpeg'), # 配置するパスやファイル名によって変更すること
        local: 'ja-JP'
      },
      # Twitter用の設定を個別で設定する
      twitter: {
        card: 'summary_large_image', # Twitterで表示する場合は大きいカードにする
        site: '@', # アプリの公式Twitterアカウントがあれば、アカウント名を書く
        image: image_url('sample.jpeg') # 配置するパスやファイル名によって変更すること
      }
    }
  end
end