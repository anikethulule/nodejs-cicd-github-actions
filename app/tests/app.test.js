const request = require("supertest");
const app = require("../src/app");

describe("Node.js Static Website Kubernetes App", () => {
  test("GET / should return static website HTML", async () => {
    const response = await request(app).get("/");

    expect(response.statusCode).toBe(200);
    expect(response.text).toContain("Static Website Deployed on Kubernetes");
  });

  test("GET /health should return health status", async () => {
    const response = await request(app).get("/health");

    expect(response.statusCode).toBe(200);
    expect(response.body.status).toBe("UP");
    expect(response.body.service).toBe("nodejs-static-website-k8s");
  });

  test("GET /api/info should return app information", async () => {
    const response = await request(app).get("/api/info");

    expect(response.statusCode).toBe(200);
    expect(response.body.app).toBe("Static Website using Node.js");
    expect(response.body.deployedOn).toBe("Kubernetes");
    expect(response.body.provisionedBy).toBe("Terraform");
  });
});