# Project Technical Details: Autonomous Vehicle RL

This document explains the architecture, methodologies, and learning process used in this autonomous vehicle reinforcement learning project.

## 1. Technologies & Environment
*   **Simulator:** CARLA 0.9.10 (UE4-based high-fidelity simulator).
*   **Language:** Python 3.7.9 (selected for specific CARLA 0.9.10 API compatibility).
*   **Deep Learning Framework:** TensorFlow 2.11.0 with Keras (using `compat.v1` for legacy support).
*   **Agent Architecture:** Actor-Critic (DDPG).

## 2. Methodology: Reinforcement Learning (RL)
The project follows a **Deep Deterministic Policy Gradient (DDPG)** approach, which is an actor-critic algorithm specifically designed for continuous action spaces (like steering and throttle).

### A. The "Brain" (Neural Networks)
*   **The Actor:** Learns the "Policy." It takes the current state (what the car sees) and decides the best actions (Steering and Throttle).
*   **The Critic:** Learns the "Value." It evaluates the actions taken by the Actor and tells it if they were good or bad.

### B. State Representation (Input)
The car understands its surroundings through:
*   **Local Waypoints:** A vector of coordinates showing the relative path ahead.
*   **Visual Data (Optional):** CNN networks (like PilotNet) for processing camera images.
*   **Kinematics:** Current velocity and heading angle.

### C. Reward Counting & Penalties (The "Points")
The AI's score is calculated in every frame based on its performance. Here is how points are added or "cut":

*   **Progress Reward (Positive):** 
    `Reward = Velocity × Alignment`
    *   The car gets more points for driving **faster** (KMH).
    *   Points are added for staying **aligned** with the road (Low angle).
*   **Centrality Penalty (Cutting Points):**
    The further the car moves away from the **center of the lane**, the more points are subtracted from the progress reward.
*   **Major Penalties (The "Big Cuts"):**
    *   **Collision:** **-200 points** (Instant end of episode).
    *   **Lane Departure:** **-200 points** (Instant end of episode if it crosses the line).
*   **Bonus Reward:**
    *   **Reaching the Destination:** **+100 points.**

## 3. How the Learning Improves
1.  **Exploration:** Initially, the car drives somewhat randomly.
2.  **Experience Replay:** Every "memory" (state, action, reward) is stored in a **Replay Buffer**.
3.  **Batch Training:** The AI randomly samples many memories from the buffer to train the networks. This ensures it learns from both past mistakes and successes.
4.  **Target Networks:** We use "Target" versions of the networks that update slowly, which provides stability during the learning process.
5.  **Iteration:** Over 8,000 episodes, the Actor gradually learns to maximize the Critic's score, resulting in smoother and safer driving.

## 4. Project Features

### ✅ Automatic Training Resume
The system automatically saves your training progress every 3 episodes and resumes from the last checkpoint when you restart training.

**How it works:**
- Actor and Critic weights are saved to `rl_agent_09/data/data_WAYPOINTS_CARLA/`
- On startup, the system automatically loads the most recent weights
- Training continues from where you left off

### ✅ Two Operating Modes

#### 🎓 Training Mode (`train.bat`)
- **Purpose:** Train the agent and improve performance progressively over time
- **Cumulative Learning:** Every time you run `train.bat`, it loads the *last saved weights* and continues training from where you left off. The knowledge stacks across all your training sessions!
- **Behavior:** Saves progress every 3 episodes to `RANDOM_actor.h5` and `RANDOM_critic.h5`
- **Use when:** You want the car to learn and get better. Train whenever you have time!

#### 🎬 Demo Mode (`demo.bat`)
- **Purpose:** Showcase the trained agent's cumulative performance
- **Behavior:** Uses the single latest saved weights file (`RANDOM_actor.h5`). It uses all the knowledge accumulated across *all* your past training sessions combined up to that point. NO training or modification occurs. The car will **continue driving** even after reaching waypoints.
- **Use when:** You want to demonstrate the car's current intelligence level and see continuous autonomous driving. As you complete more training sessions, the demo automatically gets better!

### ✅ Progress Monitoring
*   **TensorBoard:** Visualizes the "Learning Curve." An upward trend in the `average_reward` graph confirms the model is improving.
*   **Weights:** Saved in `.h5` format in `rl_agent_09/data/`. These represent the learned "knowledge."

---

## 5. How to Use This Project

### Prerequisites
Make sure CARLA simulator and Python 3.7 environment are installed (see setup scripts if needed).

### Step 1: Start the Simulator
Open a terminal and run:
```powershell
scripts\start_carla.bat
```
Wait for the CARLA window to appear and the map to load.

### Step 2A: Training Mode (Learn & Improve)
Open a **second terminal** and run:
```powershell
scripts\train.bat
```
**What happens:**
- The car will start driving and learning
- Progress is automatically saved every 3 episodes
- If you stop and restart, training resumes from the last checkpoint
- Let it run for many episodes (hundreds or thousands) to see improvement

### Step 2B: Demo Mode (Showcase Trained Performance)
Open a **second terminal** and run:
```powershell
scripts\demo.bat
```
**What happens:**
- The car runs using previously trained weights
- NO training occurs - purely demonstration
- Perfect for showing the difference between trained and untrained behavior

### Step 3: Monitor Progress (Optional)
To check how much you've trained or see the progress graphs:

**Option A: Quick Progress Check**
Open a terminal and run:
```powershell
scripts\check_progress.bat
```
This instantly shows you all saved weights, milestone episodes reached, and overall training status.

**Option B: Live TensorBoard Graphs**
1. Open a **third** terminal
2. Run this command:
   ```powershell
   .\venv37\Scripts\python.exe -m tensorboard.main --logdir=rl_agent_09/logs
   ```
3. Open your browser and go to: **http://localhost:6006**

You'll see graphs showing how the car's performance improves over time!

---

## 6. Understanding the Results

### Where Are Weights Saved?
- **Location:** `rl_agent_09/data/data_WAYPOINTS_CARLA/`
- **Files:** 
  - `RANDOM_actor.h5` - The decision-making brain
  - `RANDOM_critic.h5` - The evaluation brain
- **Best weights:** Files with `_best_reward_` prefix contain the best performing models

### How to Know If It's Learning?
1. **TensorBoard:** Check if `average_reward` graph trends upward
2. **Observation:** The car should crash less and drive smoother over time
3. **Console Output:** Episode rewards should generally increase

---


