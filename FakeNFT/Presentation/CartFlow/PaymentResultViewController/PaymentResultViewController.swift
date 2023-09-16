import UIKit

// MARK: - PaymentResultViewController class

/**
 ``PaymentResultViewController`` - это контроллер, который отображает результат оплаты заказа и позволяет пользователю вернуться в корзину или перейти в каталог
 
 В зависимости от результата оплаты, на экране отображается изображение, лейбл и кнопка для перехода к каталогу или повторной оплаты.
 Также класс обрабатывает нажатие на кнопку и передает результат оплаты в ``OrderPaymentViewModel``.
 */
final class PaymentResultViewController: UIViewController {

    // MARK: - Properties

    /// Вертикальный стек, содержащий изображение результата оплаты и надпись
    private lazy var resultStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.spacing = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    /// Изображение результата оплаты
    private lazy var resultImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = isSuccessImage()
        return view
    }()

    /// Надпись результата оплаты
    private lazy var resultTitleLabel: UILabel = {
        let label = UILabel()
        label.text = isSuccessTitleLabel()
        label.textColor = UIColor.NFTColor.black
        label.font = UIFont.NFTFont.bold22
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    /// Кнопка возврата к каталогу или повторной оплате через корзину
    private lazy var resultButton: UIButton = {
        let button = UIButton(type: .system)
        button.configure(
            with: .payment,
            for: isSuccessButtonTitle(),
            height: 60
        )
        button.addTarget(
            self,
            action: #selector(resultButtonTapped),
            for: .touchUpInside
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    /// Флаг успешности оплаты
    private let isSuccess: Bool

    /// Вью-модель для обработки результата оплаты
    private let viewModel: OrderPaymentViewModelProtocol

    /// Генератор тактильной обратной связи результата оплаты
    private let resultFeedbackGenerator: UINotificationFeedbackGenerator

    /// Проигрыватель звука результата оплаты
    private let soundPlayer: PaymentResultSoundPlayer?

    // MARK: - Initializers

    /**
     Создает новый объект ``PaymentResultViewController`` с указанной вью-моделью результата оплаты заказа
     
     В инициализаторе также создаются экземпляры генератора тактильной обратной связи `UINotificationFeedbackGenerator` и проигрывателя звука результата оплаты ``PaymentResultSoundPlayer``
     - Parameters:
        - isSuccess: Флаг успешности оплаты - ``PaymentResultNetworkModel/success``
        - viewModel: ``OrderPaymentViewModelProtocol`` для обработки результата оплаты
     */
    init(_ isSuccess: Bool, viewModel: OrderPaymentViewModelProtocol) {
        self.isSuccess = isSuccess
        self.viewModel = viewModel
        self.resultFeedbackGenerator = UINotificationFeedbackGenerator()

        let soundFileName = isSuccess ? Constants.Cart.successSound : Constants.Cart.failureSound
        self.soundPlayer = PaymentResultSoundPlayer(with: soundFileName)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.NFTColor.white
        addSubviews()
        isSuccessFeedback()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        soundPlayer?.play()
        isSuccess ? animateSuccess() : animateFailure()
    }
}

// MARK: - Add Subviews

private extension PaymentResultViewController {

    func addSubviews() {
        addResultStackView()
        addResultButton()
    }

    func addResultStackView() {
        view.addSubview(resultStackView)
        resultStackView.addArrangedSubview(resultImageView)
        resultStackView.addArrangedSubview(resultTitleLabel)

        NSLayoutConstraint.activate([
            resultStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            resultStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 26),
            resultStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26)
        ])
    }

    func addResultButton() {
        view.addSubview(resultButton)

        NSLayoutConstraint.activate([
            resultButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            resultButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            resultButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
}

// MARK: - Private methods

private extension PaymentResultViewController {

    /// Анимирует скейлом вертикальный стек при успешном результате оплаты
    func animateSuccess() {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 1,
            animations: { [weak self] in
                self?.resultStackView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            },
            completion: { _ in
                UIView.animate(
                    withDuration: 0.3,
                    delay: 0,
                    usingSpringWithDamping: 0.7,
                    initialSpringVelocity: 1,
                    animations: { [weak self] in
                        self?.resultStackView.transform = .identity
                    }
                )
            }
        )
    }

    /// Анимирует тряской вертикальный стек при неуспешном результате оплаты
    func animateFailure() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = 0.5
        animation.values = [-6.0, 6.0, -6.0, 6.0, -3.0, 3.0, -1.0, 1.0, 0.0]
        resultStackView.layer.add(animation, forKey: "failureAnimation")
    }

    /**
     Возвращает изображение в зависимости от результата оплаты
     - Returns: Изображение результата оплаты
     */
    func isSuccessImage() -> UIImage? {
        isSuccess ? UIImage.NFTImage.successPaymentResult : UIImage.NFTImage.failurePaymentResult
    }

    /**
     Возвращает надпись в зависимости от результата оплаты
     - Returns: Надпись результата оплаты
     */
    func isSuccessTitleLabel() -> String {
        isSuccess ? Constants.Cart.successPaymentResultText : Constants.Cart.failurePaymentResultText
    }

    /**
     Возвращает надпись для кнопки в зависимости от результата оплаты
     - Returns: Надпись кнопки результата оплаты
     */
    func isSuccessButtonTitle() -> String {
        isSuccess ? Constants.Cart.backToCatalogue : Constants.Cart.tryAgain
    }

    /// Генерирует тактильную обратную связь в зависимости от результата оплаты
    func isSuccessFeedback() {
        resultFeedbackGenerator.prepare()
        resultFeedbackGenerator.notificationOccurred(isSuccess ? .success : .error)
    }

    /**
     Обрабатывает нажатие на кнопку возврата к каталогу или повторной оплате через корзину
     - Вызывает метод ``OrderPaymentViewModelProtocol/handlePaymentResult(_:)`` и передает туда результат оплаты
        - В зависимости от результата оплаты, метод ``OrderPaymentViewModelProtocol/handlePaymentResult(_:)``
     вызовет обработчик ``OrderPaymentViewModel/paymentResultHandler`` и передаст туда результат оплаты
     - Скрывает экран ``PaymentResultViewController``
     */
    @objc func resultButtonTapped() {
        viewModel.handlePaymentResult(isSuccess)
        dismiss(animated: true)
    }
}
