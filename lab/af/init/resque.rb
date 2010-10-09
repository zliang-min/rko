require 'resque'
Resque.redis = ArticleCollector::Settings.redis
Resque.redis.namespace = 'resque:article_collector'
