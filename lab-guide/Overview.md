## Overview

The Acme-fitness application is an online shopping platform for having the best equipment to make you fit. This application is composed of several services like three Java Spring Boot applications (a catalog service for fetching available products, a payment service for processing and approving payments for users' orders, an identity service for referencing the authenticated user) ,
one Python application (a cart service for managing a users' items that have been selected for purchase), one ASP.NET Core applications (an order service for placing orders to buy products that are in the users' carts) and one NodeJS and static HTML Application (a frontend shopping application).

## Hands-on Labs Scenario
In this hands-on lab, you will deploy existing demo application written in Java, Python, and C# to Azure using Spring apps instance. Azure Spring Apps enables you to easily run Spring Boot and polyglot applications on Azure. When you're finished, you can continue to manage the application via the Azure CLI or switch to using the Azure Portal.

## Lab Context
Throughout this hands-on lab, you will learn several things:

- Provision an Azure Spring Apps service instance.
- Configure Application Configuration Service repositories
- Deploy polyglot applications to Azure and build using Tanzu Build Service
- Configure routing to the applications using Spring Cloud Gateway
- Open the application
- Explore the application API with Api Portal
- Configure Single Sign On (SSO) for the application
- Monitor applications
- Automate provisioning and deployments using GitHub Actions

## Architecture

![acme-fitness](Images/architecture.png)
