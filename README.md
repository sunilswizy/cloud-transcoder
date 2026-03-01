# Cloud Transcoder

A scalable, event-driven video transcoding pipeline built using **Python, AWS, Docker, and Auto Scaling**.

Cloud Transcoder automatically processes uploaded videos into multiple resolutions and serves them globally through **CloudFront CDN**.

---

## Overview

Cloud Transcoder is designed as a distributed, fault-tolerant system that:

* Accepts video uploads via S3
* Processes videos asynchronously
* Transcodes into multiple resolutions using FFmpeg
* Stores processed videos in S3
* Serves content globally via CloudFront
* Auto-scales workers based on load

---

## Architecture
<img width="1325" height="727" alt="image" src="https://github.com/user-attachments/assets/c5ea962c-af85-4f6c-8df4-1364370ca562" />



### End-to-End Flow

### Upload Phase

* Client uploads video to **Amazon S3** (same bucket)
* S3 triggers an event notification

### Event Propagation

* S3 publishes event to **Standard SQS**
* Message contains:

  * Bucket name
  * Object key
  * Event metadata

### Worker Processing (EC2 + Docker)

* EC2 instances (inside Auto Scaling Group) poll SQS
* Worker runs inside Docker container
* Python app:

  1. Downloads video from S3
  2. Transcodes using FFmpeg
  3. Generates:

     * 180p
     * 360p
     * 720p
     * 1080p
  4. Deletes SQS message on success

If processing fails:

* Message becomes visible again
* After max retries → moved to Dead Letter Queue

### CDN Delivery

* CloudFront is attached to the same S3 bucket
* Processed videos served globally with low latency

---

## Auto Scaling Strategy

Scaling is driven by **SQS queue depth**.

### CloudWatch Metric

* `ApproximateNumberOfMessagesVisible`

### Scaling Policy

| Queue Size | Action                   |
| ---------- | ------------------------ |
| > 0        | Scale up EC2 instances   |
| = 0        | Scale down EC2 instances |

This ensures:

* No idle compute cost
* Automatic spike handling
* Efficient resource utilization

---

## Tech Stack

* **Python (Plain Python)**
* **boto3**
* **FFmpeg**
* **Docker**
* **AWS S3**
* **AWS SQS (Standard)**
* **AWS EC2**
* **Launch Template**
* **Auto Scaling Group**
* **CloudWatch**
* **CloudFront**
* **GitHub Actions (CI/CD)**
---

## Local Development

```bash
pip install -r requirements.txt
python app/main.py
```

Requirements:

* AWS credentials configured
* FFmpeg installed locally
* Access to SQS and S3

---

## What This Project Demonstrates

* Distributed system design
* Event-driven architecture
* Queue-based processing
* Infrastructure auto-scaling
* Cloud-native backend engineering
* Cost-optimized architecture
* CI/CD integration
* Production-grade fault tolerance

---

### Author

Sunil
Software Engineer.
---


