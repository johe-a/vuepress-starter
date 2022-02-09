module.exports = {
  theme: 'reco',
  title: 'johe的个人博客',
  description: 'johe的个人博客',
  base: '/vuepress-starter/',
  locales: {
    '/': {
      lang: 'zh-CN'
    }
  },
  themeConfig: {
    subSidebar: 'auto',
    nav: [
      {
        text: '首页',
        link: '/'
      },
      {
        text: 'johe的github博客',
        items: [
          {
            text: 'Github',
            link: 'https://github.com/mqyqingfeng'
          },
          {
            text: '掘金',
            link: 'https://juejin.cn/user/712139234359182/posts'
          }
        ]
      }
    ],
    sidebar: [
      {
        title: '欢迎学习',
        path: '/',
        collapsable: true,
        children: [
          {
            title: '学前必读',
            path: "/"
          }
        ]
      },
      {
        title: '基础学习',
        path: '/handbook/ConditionalTypes',
        collapsable: false,
        children: [
          {
            title: '条件类型',
            path: '/handbook/ConditionalTypes',
          },
          {
            title: '泛型',
            path: '/handbook/Generics'
          }
        ]
      }
    ]
  }
}