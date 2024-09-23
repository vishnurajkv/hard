---
- hosts: localhost
  connection: local
  become: yes
  tasks:  
    - name: Installing dependencies
      apt:
        name:
          - linux-headers-generic
          - build-essential
          - pipx
        state: present
        install_recommends: yes

    - name:  adding GPU PPA
      apt_repository:
        repo: ppa:graphics-drivers/ppa
        state: present

    - name: Installing  driver
      apt:
        name: nvidia-driver-470
        state: present

    - name: Add deadsnakes PPA
      apt_repository:
        repo: ppa:deadsnakes/ppa
        state: present

    - name: Installing Python 3.11
      apt:
        name: python3.11
        state: present

    - name: Download and install pip
      shell: curl -sS https://bootstrap.pypa.io/get-pip.py | python3.11
      args:
        executable: /bin/bash





------------------------------------------------------



rebooot



-----------------------------------------------------



---
- hosts: localhost
  connection: local
  become: yes
  tasks:
    - name: Installing poetry 
      shell: sleep 20 && apt install -y python3-poetry
      args:
        executable: /bin/bash

    - name: Installing ollama
      shell: curl -fsSL https://ollama.com/install.sh | sh
      args:
        executable: /bin/bash

    - name: Pull Mistral llm
      shell: ollama pull mistral
      args:
        executable: /bin/bash

    - name: Pull Nomic Embed Text llm
      shell: ollama pull nomic-embed-text
      args:
        executable: /bin/bash

    - name: Start Ollama service
      shell: ollama serve
      async: 300
      poll: 0
      args:
        executable: /bin/bash

    - name: Clone privateGPT 
      git:
        repo: https://github.com/imartinez/privateGPT.git
        dest: privateGPT

    - name: Install privateGPT dependencies
      shell: cd privateGPT && poetry install --extras "ui llms-ollama embeddings-ollama vector-stores-qdrant"
      args:
        executable: /bin/bash

    - name: Run privateGPT
      shell: cd privateGPT && PGPT_PROFILES=ollama make run
      poll: 0
      args:
        executable: /bin/bash
