module ApplicationHelper
    def default_meta_tags
    {
      site: 'スマプラ！',
      title: 'あなたのスマイルに値段を！',
      reverse: true,
      charset: 'utf-8',
      description: 'あなたのスマイルに値段をつけて、値段にあったマックメニューを提案します！',
      keywords: 'スマイル診断,マクドナルド',
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