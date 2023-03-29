$(document).ready(function () {
  // MenuBarをクリックした場合の処理
  $("#MenuBar").click(function () {
    // MenuListを表示
    $("#MenuList").removeClass("hidden");
  });

  // MenuCloseをクリックした場合の処理
  $("#MenuClose").click(function () {
    // MenuListを非表示
    $("#MenuList").addClass("hidden");
  });
  // メニューバー以外の場所をクリックした場合の処理
  $(document).click(function (event) {
    // クリックされた要素がメニューバーでない場合、MenuListを非表示
    if (!$(event.target).closest('#MenuBar').length) {
      $("#MenuList").addClass("hidden");
    }
  });
});