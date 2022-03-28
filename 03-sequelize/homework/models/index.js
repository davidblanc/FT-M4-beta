var { Sequelize, DataTypes } = require('sequelize');
const S = Sequelize;
var db = new Sequelize('postgres://henry1:1234@localhost:5432/henryblog', {
  logging: false,
});

const Page = db.define('page', {
  // Tu código acá:
  title: {
    type: DataTypes.STRING,
    allowNull: false
  },
  urlTitle: {
    type: DataTypes.STRING,
    allowNull: false
  },
  content: {
    type: DataTypes.TEXT,
    allowNull: false
  },
  status: {
    type: DataTypes.ENUM('open', 'closed')
  },
  route: {
    type: DataTypes.VIRTUAL,
    get: function () {
      return `/pages/${this.urlTitle}`
    }
  }

});

// .addHook() method
Page.beforeValidate(page => {
  page.urlTitle = page.title && page.title.replace(/\s+/g, '_').replace(/\W/g, '');
})

const User = db.define('users', {
  name:{
    type: DataTypes.STRING,
    allowNull: false
  },
  email:{
    type: DataTypes.STRING,
    allowNull: false,
    unique:true
  }
});

const Category = db.define('category', {
  // Tu código acá:
  name:{
    type: DataTypes.STRING,
    allowNull: false,
    unique:true
  },
  description:{
    type: DataTypes.STRING
  } 
});

// Vincular User con Page
// Tu código acá:
Page.belongsTo(User);
User.hasMany(Page);

Page.belongsToMany(Category,{ through: 'category_page'})
Category.belongsToMany(Page,{ through: 'category_page'})


module.exports = {
  User,
  Page,
  Category,
  db
}
