const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

// Get Logged-in User Profile
async function getUserProfile(req, res) {
  try {
    const user = await prisma.user.findUnique({
      where: { id: req.user.userId },
      include: { addresses: true },
    });

    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    // Strip password hash from response
    const { password, ...userProfile } = user;
    return res.json(userProfile);
  } catch (error) {
    console.error('Fetch profile error:', error);
    return res.status(500).json({ error: error.message });
  }
}

// Update User Profile
async function updateUserProfile(req, res) {
  try {
    const { name, phone } = req.body;

    const updatedUser = await prisma.user.update({
      where: { id: req.user.userId },
      data: {
        ...(name && { name }),
        ...(phone && { phone }),
      },
      include: { addresses: true },
    });

    const { password, ...userProfile } = updatedUser;
    return res.json({
      message: 'Profile updated successfully',
      user: userProfile,
    });
  } catch (error) {
    console.error('Update profile error:', error);
    return res.status(500).json({ error: 'Profile update failed.' });
  }
}

module.exports = {
  getUserProfile,
  updateUserProfile,
};