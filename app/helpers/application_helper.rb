module ApplicationHelper
    def smile_analysis_score_attributes 
      {
        '目の表情' => :eye_expression_score,
        '口元の表情' => :mouth_expression_score, 
        '鼻の位置' => :nose_position_score,
        '顎の位置' => :jawline_score,
        '自然度・バランス' => :naturalness_and_balance_score,
        '総合評価' => :smile_score        
      }
    end

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