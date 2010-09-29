(function(Ext) {
  Ext.Updater.defaults.indicatorText = '<div class="loading-indicator">读取中...</div>';

  Ext.apply(Ext.PagingToolbar.prototype, {
    firstText: '首页',
    lastText: '末页',
    prevText: '上一页',
    nextText: '下一页',
    refreshText: '刷新'
  });
})(Ext);
