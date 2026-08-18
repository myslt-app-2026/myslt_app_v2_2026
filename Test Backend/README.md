# Omni-Channel
Reimplement the current APIs used in myslt app, to align those with TMF specifications

## Project Structure

### Controllers, Services, and Routes
- Place all service, route, and controller classes inside the `src/controller/name/endpoint` folder. 
- Example: src/BBVAS/addVASDataBundlePostPaid/controllers/ServiceOrderController.js
- Ensure that each endpoint has its own dedicated folder under `src/controllerName`.
- Example controllers = BBVAS, Account, PEO, PEOVAS, Prepaid
- Example:
  - For the `RegisterV2` endpoint:
    - Controller: `src/Account/RegisterV2/controller.js`
    - Service: `src/Account/RegisterV2/service.js`
    - Route: `src/Account/RegisterV2/routes.js`


### Models
- Place all models inside the `src/models` folder.
- Naming convention: `TMF<Number>_<ModelName>.js`
  - Example: `TMF699_SalesLead.js`
- When using a model in a controller or service class, import it from the `src/models` folder.
  - Example:
    ```javascript
    const SalesLead = require("../../models/TMF699_SalesLead");
    ```

### Route Integration
- Import the route file inside `app.js`.
- Assign it a route using `app.use()`.
  - Example:
    ```javascript
    const register = require("./Account/RegisterV2/routes/registerroutes");
    app.use("/tmf-api", register);
    ```

## Reimplementing Original Endpoints

When you are assigned to reimplement an original endpoint, follow these steps:

1. **Understand the Existing Endpoint**
   - Analyze what the endpoint does and its purpose.
   - Gather all necessary details about its functionality.

2. **Select the Appropriate TMF API**
   - Identify the most suitable TMF API for the endpoint.
   - Choose the correct endpoint from the TMF API that aligns with the functionality.

3. **Create the Model**
   - Use the user guide of the selected TMF API to design the most accurate model.
   - Follow the naming convention: `TMF<Number>_<ModelName>.js`.

4. **Implement the Endpoint**
   - Develop the controller, service, and route files for the endpoint.
   - Ensure the implementation adheres to the TMF API specifications.

## Branching and Pull Request Practices

1. **Create a New Branch for Related Endpoints**
   - Always create a new branch for related endpoints.
   - Example: Since `RegisterV2`, `LogIn`, `OTP Verification`, and `ResendOTP` are related, create a new branch from the main branch named something like 
   `Authentication_<yourName>`
   - Example: Authentication_malsha

2. **Merge the `dev` Branch Before PR**
   - Always merge the `dev` branch into your branch before creating a pull request (PR).

3. **Send PRs to the `dev` Branch Only**
   - Ensure that all pull requests are sent to the `dev` branch only.

4. **Avoid Direct Commits to `dev` or `main`**
   - Never commit directly to the `dev` or `main` branches.
   - Always use pull requests for any changes.

## Authentication

The system uses JWT-based authentication.

### Access Token
- Short-lived
- Used for API authorization
- Sent via Authorization header

### Refresh Token
- Long-lived
- Used to reissue access tokens

### Environment Variables
- Store sensitive information such as database connection strings and JWT secrets in the `.env` file.

### Models
- Add all the models in the `src/models` folder.
- Naming structure: `TMFNumber_modelName.js`
  - Example: `TMF699_SalesLead.js`

Tokens are issued after successful OTP verification.
