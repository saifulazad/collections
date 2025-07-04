import http from 'k6/http';
import { check, sleep } from 'k6';

export let options = {
  vus: 120,          // 10 virtual users
  duration: '1m',  // run test for 30 seconds
};

const url = 'https://cv-doctor-15805443401.us-central1.run.app/store-cv-data';

const payload = JSON.stringify({
  collectionName: "cvs",
  documentName: "user123",
  data: {
    name: "Rafiqul Islam Rabbi",
    email: "rafiqulislamrabbi2546@gmail.com",
    skills: ["Python", "Django", "GCP"],
    experience: 2,
    education: {
      degree: "BSc in Computer Science",
      university: "Dhaka University"
    }
  }
});

const params = {
  headers: {
    'Content-Type': 'application/json',
  },
};

export default function () {
  const res = http.post(url, payload, params);

  check(res, {
    'status is 200': (r) => r.status === 200,
    'response contains success': (r) => r.body && r.body.toLowerCase().includes('success'),
  }) || console.log(`Failed request: status ${res.status} body: ${res.body}`);

  sleep(1);  // wait 1 second between requests
}
