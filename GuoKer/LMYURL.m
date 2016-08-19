
NSString * const baseURL = @"http://www.guokr.com";
/**
 *  获得精选id
 */
NSString * const Home_adPickid = @"/apis/flowingboard/item/handpick_carousel.json";

/**
 *  获得精选详细内容 /apis/handpick/v2/article.json
 */
NSString * const  Home_handpickDetail = @"/apis/handpick/v2/article.json" ;

/**
 *  获取全部的文章 /apis/handpick/v2/article.json?limit=20&retrieve_type=by_offset&ad=1&offset=0
 */
NSString * const  Home_allArticle = @"/apis/handpick/v2/article.json";

/**
 *  反馈: http://www.guokr.com/apis/handpick/feedback.json   address	: qq or email
 content : [iPhone][9.0.2][4.2.1]thx
 */
NSString * const Feedback_url = @"http://www.guokr.com/apis/handpick/feedback.json";

/**
 *  关键词:http://www.guokr.com/apis/flowingboard/flowingboard.json?name=handpick_search_keywords
 */
NSString * const Search_keywords = @"http://www.guokr.com/apis/flowingboard/flowingboard.json?name=handpick_search_keywords";