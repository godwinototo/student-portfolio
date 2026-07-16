/* ============================================================
   Student Portfolio - Shared JavaScript
   Handles: Academic Planner + Contact Form validation
   ============================================================ */
/* -------------------- ACADEMIC PLANNER -------------------- */
(function initPlanner() {
  const form = document.getElementById('task-form');
  const input = document.getElementById('task-input');
  const list = document.getElementById('task-list');
  const emptyMsg = document.getElementById('task-empty');
  if (!form || !input || !list) return; // Only run on planner page
  // In-memory task array (also persisted to localStorage)
  let tasks = [];
  try {
    const stored = localStorage.getItem('planner-tasks');
    if (stored) tasks = JSON.parse(stored);
  } catch (e) { tasks = []; }
  function save() {
    localStorage.setItem('planner-tasks', JSON.stringify(tasks));
  }
  function render() {
    list.innerHTML = '';
    if (tasks.length === 0) {
      emptyMsg.style.display = 'block';
      return;
    }
    emptyMsg.style.display = 'none';
    tasks.forEach((task) => {
      const li = document.createElement('li');
      li.className = 'task-item' + (task.completed ? ' completed' : '');
      const checkbox = document.createElement('input');
      checkbox.type = 'checkbox';
      checkbox.checked = task.completed;
      checkbox.addEventListener('change', () => {
        task.completed = checkbox.checked;
        save();
        render();
      });
      const span = document.createElement('span');
      span.className = 'task-text';
      span.textContent = task.text;
      const delBtn = document.createElement('button');
      delBtn.className = 'task-delete';
      delBtn.type = 'button';
      delBtn.textContent = 'Delete';
      delBtn.addEventListener('click', () => {
        tasks = tasks.filter((t) => t.id !== task.id);
        save();
        render();
      });
      li.appendChild(checkbox);
      li.appendChild(span);
      li.appendChild(delBtn);
      list.appendChild(li);
    });
  }
  form.addEventListener('submit', (e) => {
    e.preventDefault();
    const text = input.value.trim();
    if (!text) return;
    tasks.push({ id: Date.now(), text, completed: false });
    input.value = '';
    save();
    render();
  });
  render();
})();
/* -------------------- CONTACT FORM VALIDATION -------------------- */
(function initContactForm() {
  const form = document.getElementById('contact-form');
  if (!form) return;
  const success = document.getElementById('form-success');
  const fields = {
    name: document.getElementById('name'),
    email: document.getElementById('email'),
    phone: document.getElementById('phone'),
    message: document.getElementById('message'),
  };
  function setError(fieldName, message) {
    const err = form.querySelector(`[data-error-for="${fieldName}"]`);
    const wrapper = fields[fieldName].closest('.field');
    if (err) err.textContent = message;
    if (wrapper) wrapper.classList.toggle('invalid', Boolean(message));
  }
  function validate() {
    let ok = true;
    // Name
    if (!fields.name.value.trim()) {
      setError('name', 'Name is required.');
      ok = false;
    } else {
      setError('name', '');
    }
    // Email
    const emailVal = fields.email.value.trim();
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailVal) {
      setError('email', 'Email is required.');
      ok = false;
    } else if (!emailRegex.test(emailVal)) {
      setError('email', 'Please enter a valid email address.');
      ok = false;
    } else {
      setError('email', '');
    }
    // Phone - digits only
    const phoneVal = fields.phone.value.trim();
    const phoneRegex = /^\d+$/;
    if (!phoneVal) {
      setError('phone', 'Phone number is required.');
      ok = false;
    } else if (!phoneRegex.test(phoneVal)) {
      setError('phone', 'Phone number must contain digits only.');
      ok = false;
    } else {
      setError('phone', '');
    }
    // Message
    if (!fields.message.value.trim()) {
      setError('message', 'Message cannot be empty.');
      ok = false;
    } else {
      setError('message', '');
    }
    return ok;
  }
  // Live validation feedback
  Object.keys(fields).forEach((key) => {
    fields[key].addEventListener('input', () => {
      if (form.querySelector('.field.invalid')) validate();
    });
  });
  form.addEventListener('submit', (e) => {
    e.preventDefault();
    success.hidden = true;
    if (!validate()) return;
    // Simulate sending
    success.hidden = false;
    form.reset();
    setTimeout(() => { success.hidden = true; }, 5000);
  });
})();
