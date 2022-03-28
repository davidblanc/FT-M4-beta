const router = require('express').Router();
const { Page, User } = require('../models');


router.post('/', async function (req, res) {
  // Modificar para que cuando se clickee el botón de "SUBMIT" se cree un nuevo post
  // tomando los datos desde el form y agregándolo a la base de datos
  // (Debe incluir también la categoría a la/s cual/es pertenece)
  // Tu código acá:
  // {
  //   title: 'hola',
  //   content: 'chau',
  //   authorEmail: 'toni@toni.com',
  //   authorName: 'Franco',
  //   categories: [1]
  // }

  const { title, content, authorEmail, authorName, categories } = req.body;
  const [user, created] = await User.findOrCreate({
    where: {
      name: authorName,
      email: authorEmail
    }
  })

  const page = await Page.create({
    title,
    content,
    status:'open'
  });

  await user.addPages(page);
  console.log(categories);
  await page.setCategories(categories);

  res.redirect(page.route);
});

router.get('/add', function (req, res) {

  res.render('addpage');
});


router.get('/:urlTitle', async function (req, res) {
  // Modificar para que cuando se seleccione un "Page" en particular se muestren
  // los datos asociados al mismo
  // Tu código acá:
  const { urlTitle } = req.params;

  const page = await Page.findOne({
    where: {
      urlTitle: urlTitle
    }
  })
  if (!page) return res.status(404).render('error')
  
  res.render('page', { page })
});

module.exports = router;
