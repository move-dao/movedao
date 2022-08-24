# MoveDAO 

MoveDAO 是一个链上链下结合的DAO平台

-  产品主要功能流程(初稿)
    1. use case：发起项目提案
        
        填定项目标题，项目利益相关人，项目价值或解决的问题,项目总贡献值等……. 
        
    2. use case：对项目投票
        
        成员对项目进行投票(投票有截止时间)
        
    3. use case：创建项目
        
        a：投票通过后，在任务管理前端创建项目，并标记项目 PASS
        
        b：投票不通过或过期，关闭提案
        
    4.  use case：项目子任务录入
        
        项目发起人或相关人者创建项目仓库(e.g. github.com/move-dao)，把项目功能的开发任务分解成子任务，可参考WBS，并录入到系统，包含任务说明，交付条件（测试用例），交付时间，贡献值等，内容编排模式可参考用例说明(use case)模式
        
        备注：在项目没完成时，都可以对子任务进入录入和修改。
        
    5. use case：选择任务
        
        想参与的人，选择自己想做的事项或任务并提交申请。
        
    6. use case：完成任务
        
        参与者完成任务后，把相关文档，代码和测试用例提交到项目仓库，并提交完成任务申请
        
    7. use case：任务验证
        
        项目发起人或相关人验证完成任务申请，然后向链上提案发放贡献值给任务完成者，或者通过多签的方式发放链上贡献值。
        
    8. use case：完成项目提案
        
        在项目所有子任务后，项目发起人或相关人在链上发起提案，提案内容包括但不限于项目开发的内容，项目的roadmap，下阶段的重点等。
        
    9. use case：发起项目验收测试提案
        任何人都可以参与测试并反馈
    10. use case：对完成的项目投票
        1. 投票通过，要项目完成。
        2. 投票失败，如何处理？


参考资料：
    [MoveDAO制度草案](https://pinto-muskmelon-2bc.notion.site/moveDao-85dbe8a6ba294c5ca47523245370b934)

    [估值最高的社区DAO是怎么做产品](https://www.qianba.com/news/p-434944.html)
    
    [Gitcoin Governance Process](https://gov.gitcoin.co/t/gitcoin-dao-governance-process-v2-updated/7860)