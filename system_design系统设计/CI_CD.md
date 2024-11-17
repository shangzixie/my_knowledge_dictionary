# CI/CD

It stands for continuous integration and continuous delivery/deployment.
Continuous integration (CI) refers to the practice of automatically and frequently integrating code changes into a shared source code repository.
Continuous delivery and/or deployment (CD) is a 2 part process that refers to the integration, testing, and delivery of code changes. Continuous delivery stops short of automatic production deployment, while continuous deployment automatically releases the updates into the production environment.

![1](/Image/system_design/77.png)

## CI

In modern application development, the goal is to have multiple developers working simultaneously on different features of the same app.

Successful CI means that once a developer's changes to an application are merged, those changes are validated by automatically building the application and running different levels of automated testing, typically unit and integration tests, to ensure the changes haven't broken the app.

## CD

### Continuous Delivery

Continuous delivery usually means a developer's changes to an application are automatically bug tested and uploaded to a repository (like GitHub or a container registry), where they can then be deployed to a live production environment by the operations team.

To that end, the purpose of continuous delivery is to have a codebase that is always **ready** for deployment to a production environment, and ensure that it takes minimal effort to deploy new code.

### Continuous Deployment

The **final stage** of a mature CI/CD pipeline is continuous deployment. continuous deployment is an extension of continuous delivery, and can refer to automating the release of a developer's changes from the repository to production, where it is usable by customers.

## reference

[redhat blog](https://www.redhat.com/en/topics/devops/what-is-ci-cd?cicd=32h281b)