<h1>GitHub Actions CI/CD with Docker and EKS deployment</h1>

<h2>Description</h2>
This project is aiming to create a CI/CD pipeline using GitHub actions, createing basic EKS cluster infrastrtucture with Terraform and deploying the built Docker image to AWS Elastic Kubernetes Service (EKS). The app that is containerised and deployed is a simple Flask app that just displays some text on a static html page.
The main focus was on creating the yaml file for GitHub Actions that will build and push docker image of the app to dockerhub public registry and prepare a EKS cluster infrastructure in Terraform for the later deployment of the Flask app.
<br />


<h2>Languages and Utilities Used</h2>

- <b>Python</b>
- <b>GitHub Actions</b>
- <b>Docker</b>
- <b>Terraform</b>
- <b>AWS CLI</b>
- <b>AWS EKS</b>

<h2>Project walk-through:</h2>
