<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/github_username/repo_name">
    <img src="Images/logo final white.png" alt="Logo" width="500" height="500">
  </a>

<h3 align="center">The One Stop Guide to an ESCI (Efficent Secure & Complete Infrastructure)</h3>

  <p align="center">

</div>

<!-- ABOUT THE PROJECT -->
## About The Project
The One Stop Guide to an ESCI is all about creating an efficent, secure, and complete infrastrucutre for fintech startups all at the touch of a button. The goal reason behind this project is finding an automated solution for the challenges faced by fintech startups regarding cybersecurity and infrastructure issues. 

### Built With
![image](https://github.com/Maher512/ESCI/assets/74532750/5c0251d7-d12d-4a80-9522-abec9f27ac2c)
![image](https://github.com/Maher512/ESCI/assets/74532750/fa33508d-eb89-44ae-a9ca-d2bd6e8a0df5)
![image](https://github.com/Maher512/ESCI/assets/74532750/0c7b8462-50d3-4bf2-9932-c95b33f5981d)


### Prerequisites

The only thing you need to have to use this product is to create an account to use the AWS provided services.
* Click on this link to create your AWS account
  ```sh
  https://aws.amazon.com/?nc2=h_lg
  ```

### Installation

1. Open up the managment console and startup an AWS CloudShell terminal:![Screenshot_5](https://github.com/Maher512/ESCI/assets/74532750/33e43bae-306e-4ad1-ba68-a01e31716cae)
2. Clone the repo
   ```sh
   git clone https://github.com/Maher512/ESCI
   ```
2. CD into the clone repository 
   ```sh
   cd ESCI
   ```
3. Execute the infrastructure creation script
   ```sh
   bash Infra_Creation.sh 
   ```
4. Execute the roles and policy creation script
   ```sh
   bash rolecreation.sh 
   ```

<!-- USAGE EXAMPLES -->
## Usage

After following the steps this is the topology of your created infrastructure with role-based access control implemented to protect and harden the systems: 
<br>
![Screenshot_4](https://github.com/Maher512/ESCI/assets/74532750/dbca6c34-f5c1-4c6f-8cb5-34156b7771fe)
<br>
Also, displayed below will be the resource map that visulizes the script results:
![Resource Map](https://github.com/Maher512/ESCI/assets/74532750/2f385b1f-aec2-4c38-8850-e991fb03e5c6)

<!-- ROADMAP -->
## Roadmap

- [x] Built and Maintained a Secure Network
- [x] Protected Sensitive Data
- [x] Implemented Strong Role Based Access Control Measures 
    - [x] VPC Created
    - [x] Subnets Created and Configured
    - [x] Route Tables Customized 
    - [x] SSH Security Group Implemented
    - [x] Launched EC2 Intances


<!-- CONTACT -->
## Contact

Mohamed H. Maher - mohamed.maher@tkh.edu.eg

Linkedin: (https://www.linkedin.com/in/mohamed-maher-a3a133240/)

<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

* [Dr. Haitham Ghalwash](http://www.linkedin.com/in/ghalwash)
* [Dr. Ahmed Taha]()
* [AL. Mohamed Ibrahim]()
