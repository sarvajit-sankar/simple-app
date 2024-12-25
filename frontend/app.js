document.addEventListener('DOMContentLoaded', () => {
    const API_URL = 'http://localhost:8000/api';

    // Load users on page load
    loadUsers();

    // Handle form submission
    document.getElementById('userForm').addEventListener('submit', async (e) => {
        e.preventDefault();
        
        const name = document.getElementById('name').value;
        const email = document.getElementById('email').value;

        try {
            const response = await fetch(`${API_URL}/users/`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ name, email }),
            });

            if (!response.ok) {
                throw new Error('Failed to create user');
            }

            // Clear form and reload users
            e.target.reset();
            loadUsers();
        } catch (error) {
            console.error('Error:', error);
            alert('Failed to create user');
        }
    });

    async function loadUsers() {
        try {
            const response = await fetch(`${API_URL}/users/`);
            if (!response.ok) {
                throw new Error('Failed to fetch users');
            }
            
            const users = await response.json();
            displayUsers(users);
        } catch (error) {
            console.error('Error:', error);
            document.getElementById('usersList').innerHTML = `
                <tr>
                    <td colspan="3" style="text-align: center;">Failed to load users</td>
                </tr>`;
        }
    }

    function displayUsers(users) {
        const usersList = document.getElementById('usersList');
        usersList.innerHTML = users.length ? users.map(user => `
            <tr>
                <td>${user.id}</td>
                <td>${user.name}</td>
                <td>${user.email}</td>
            </tr>
        `).join('') : `
            <tr>
                <td colspan="3" style="text-align: center;">No users found</td>
            </tr>`;
    }
});